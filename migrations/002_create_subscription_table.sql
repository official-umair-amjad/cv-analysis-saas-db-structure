-- Migration: Create subscription table for billing and subscription management
-- This migration adds a subscription table to handle billing cycles and subscription details

-- Create subscription plans table (reference data)
CREATE TABLE subscription_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    price_monthly DECIMAL(10,2) NOT NULL,
    price_yearly DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    max_users INTEGER NOT NULL,
    max_jobs_per_month INTEGER NOT NULL,
    max_candidates INTEGER,
    max_storage_gb INTEGER,
    features JSONB DEFAULT '{}', -- Store feature flags and limits
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create subscriptions table (organization subscriptions)
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    plan_id UUID NOT NULL REFERENCES subscription_plans(id) ON DELETE RESTRICT,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('trial', 'active', 'past_due', 'canceled', 'unpaid', 'paused')),
    billing_cycle VARCHAR(20) DEFAULT 'monthly' CHECK (billing_cycle IN ('monthly', 'yearly')),
    current_period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    current_period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    trial_start TIMESTAMP WITH TIME ZONE,
    trial_end TIMESTAMP WITH TIME ZONE,
    cancel_at_period_end BOOLEAN DEFAULT false,
    canceled_at TIMESTAMP WITH TIME ZONE,
    stripe_subscription_id VARCHAR(255), -- External billing system reference
    stripe_customer_id VARCHAR(255), -- External billing system reference
    metadata JSONB DEFAULT '{}', -- Store additional billing metadata
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(organization_id) -- One active subscription per organization
);

-- Create subscription usage tracking table
CREATE TABLE subscription_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id) ON DELETE CASCADE,
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
    usage_date DATE NOT NULL,
    users_count INTEGER DEFAULT 0,
    jobs_created_count INTEGER DEFAULT 0,
    candidates_added_count INTEGER DEFAULT 0,
    storage_used_mb INTEGER DEFAULT 0,
    api_calls_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(subscription_id, usage_date)
);

-- Create indexes for better performance
CREATE INDEX idx_subscription_plans_slug ON subscription_plans(slug);
CREATE INDEX idx_subscription_plans_is_active ON subscription_plans(is_active);
CREATE INDEX idx_subscriptions_organization_id ON subscriptions(organization_id);
CREATE INDEX idx_subscriptions_plan_id ON subscriptions(plan_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_current_period_end ON subscriptions(current_period_end);
CREATE INDEX idx_subscriptions_stripe_subscription_id ON subscriptions(stripe_subscription_id);
CREATE INDEX idx_subscription_usage_subscription_id ON subscription_usage(subscription_id);
CREATE INDEX idx_subscription_usage_organization_id ON subscription_usage(organization_id);
CREATE INDEX idx_subscription_usage_usage_date ON subscription_usage(usage_date);

-- Add updated_at triggers
CREATE TRIGGER update_subscription_plans_updated_at BEFORE UPDATE ON subscription_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscription_usage_updated_at BEFORE UPDATE ON subscription_usage FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Update organizations table to reference current subscription
ALTER TABLE organizations 
ADD COLUMN current_subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
ADD COLUMN subscription_status VARCHAR(50) DEFAULT 'active' CHECK (subscription_status IN ('trial', 'active', 'past_due', 'canceled', 'unpaid', 'paused'));

-- Create index for the new column
CREATE INDEX idx_organizations_current_subscription_id ON organizations(current_subscription_id);
CREATE INDEX idx_organizations_subscription_status ON organizations(subscription_status);

-- Create function to get current subscription for an organization
CREATE OR REPLACE FUNCTION get_organization_current_subscription(org_id UUID)
RETURNS TABLE (
    subscription_id UUID,
    plan_name VARCHAR(100),
    plan_slug VARCHAR(50),
    status VARCHAR(50),
    billing_cycle VARCHAR(20),
    current_period_end TIMESTAMP WITH TIME ZONE,
    max_users INTEGER,
    max_jobs_per_month INTEGER,
    max_candidates INTEGER,
    max_storage_gb INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.id,
        sp.name,
        sp.slug,
        s.status,
        s.billing_cycle,
        s.current_period_end,
        sp.max_users,
        sp.max_jobs_per_month,
        sp.max_candidates,
        sp.max_storage_gb
    FROM subscriptions s
    JOIN subscription_plans sp ON s.plan_id = sp.id
    WHERE s.organization_id = org_id
    AND s.status IN ('trial', 'active')
    ORDER BY s.created_at DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to check if organization has exceeded limits
CREATE OR REPLACE FUNCTION check_organization_limits(org_id UUID)
RETURNS TABLE (
    limit_type VARCHAR(50),
    current_usage INTEGER,
    limit_value INTEGER,
    is_exceeded BOOLEAN
) AS $$
DECLARE
    current_sub RECORD;
    user_count INTEGER;
    job_count INTEGER;
    candidate_count INTEGER;
BEGIN
    -- Get current subscription
    SELECT * INTO current_sub FROM get_organization_current_subscription(org_id);
    
    IF current_sub.subscription_id IS NULL THEN
        RAISE EXCEPTION 'No active subscription found for organization %', org_id;
    END IF;
    
    -- Get current usage
    SELECT COUNT(*) INTO user_count FROM user_profiles WHERE organization_id = org_id AND is_active = true;
    SELECT COUNT(*) INTO job_count FROM jobs WHERE organization_id = org_id AND created_at >= date_trunc('month', CURRENT_DATE);
    SELECT COUNT(*) INTO candidate_count FROM candidates WHERE organization_id = org_id;
    
    -- Return limit checks
    RETURN QUERY SELECT 'users'::VARCHAR(50), user_count, current_sub.max_users, (user_count > current_sub.max_users);
    RETURN QUERY SELECT 'jobs_per_month'::VARCHAR(50), job_count, current_sub.max_jobs_per_month, (job_count > current_sub.max_jobs_per_month);
    
    IF current_sub.max_candidates IS NOT NULL THEN
        RETURN QUERY SELECT 'candidates'::VARCHAR(50), candidate_count, current_sub.max_candidates, (candidate_count > current_sub.max_candidates);
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create function to update organization subscription status
CREATE OR REPLACE FUNCTION update_organization_subscription_status()
RETURNS TRIGGER AS $$
BEGIN
    -- Update organization's subscription status when subscription changes
    UPDATE organizations 
    SET 
        subscription_status = NEW.status,
        current_subscription_id = NEW.id
    WHERE id = NEW.organization_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger to automatically update organization subscription status
CREATE TRIGGER update_org_subscription_status
    AFTER INSERT OR UPDATE ON subscriptions
    FOR EACH ROW EXECUTE FUNCTION update_organization_subscription_status();

-- Grant permissions
GRANT EXECUTE ON FUNCTION get_organization_current_subscription(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION check_organization_limits(UUID) TO authenticated;
