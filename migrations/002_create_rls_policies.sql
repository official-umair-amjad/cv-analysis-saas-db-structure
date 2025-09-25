-- Migration: Create Row Level Security (RLS) policies for multi-tenant SaaS
-- This migration enables RLS and creates policies to ensure data isolation between organizations

-- Enable RLS on all tables
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;
ALTER TABLE match_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_usage ENABLE ROW LEVEL SECURITY;

-- Helper function to get current user's organization_id
CREATE OR REPLACE FUNCTION get_user_organization_id()
RETURNS UUID AS $$
BEGIN
    RETURN (
        SELECT organization_id 
        FROM user_profiles 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Helper function to check if user is admin
CREATE OR REPLACE FUNCTION is_user_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN (
        SELECT role = 'admin' 
        FROM user_profiles 
        WHERE id = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Organizations policies
-- Users can only see their own organization
CREATE POLICY "Users can view their own organization" ON organizations
    FOR SELECT USING (id = get_user_organization_id());

-- Only admins can update their organization
CREATE POLICY "Admins can update their organization" ON organizations
    FOR UPDATE USING (id = get_user_organization_id() AND is_user_admin());

-- Only admins can insert new organizations (for super admin functionality)
CREATE POLICY "Admins can insert organizations" ON organizations
    FOR INSERT WITH CHECK (is_user_admin());

-- User profiles policies
-- Users can view profiles in their organization
CREATE POLICY "Users can view profiles in their organization" ON user_profiles
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Users can update their own profile
CREATE POLICY "Users can update their own profile" ON user_profiles
    FOR UPDATE USING (id = auth.uid());

-- Admins can insert/update profiles in their organization
CREATE POLICY "Admins can manage profiles in their organization" ON user_profiles
    FOR ALL USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Jobs policies
-- Users can view jobs in their organization
CREATE POLICY "Users can view jobs in their organization" ON jobs
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Users can create jobs in their organization
CREATE POLICY "Users can create jobs in their organization" ON jobs
    FOR INSERT WITH CHECK (
        organization_id = get_user_organization_id() 
        AND created_by = auth.uid()
    );

-- Users can update jobs they created or if they're admin
CREATE POLICY "Users can update jobs in their organization" ON jobs
    FOR UPDATE USING (
        organization_id = get_user_organization_id() 
        AND (created_by = auth.uid() OR is_user_admin())
    );

-- Admins can delete jobs in their organization
CREATE POLICY "Admins can delete jobs in their organization" ON jobs
    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Candidates policies
-- Users can view candidates in their organization
CREATE POLICY "Users can view candidates in their organization" ON candidates
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Users can create candidates in their organization
CREATE POLICY "Users can create candidates in their organization" ON candidates
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());

-- Users can update candidates in their organization
CREATE POLICY "Users can update candidates in their organization" ON candidates
    FOR UPDATE USING (organization_id = get_user_organization_id());

-- Admins can delete candidates in their organization
CREATE POLICY "Admins can delete candidates in their organization" ON candidates
    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Resumes policies
-- Users can view resumes in their organization
CREATE POLICY "Users can view resumes in their organization" ON resumes
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Users can create resumes in their organization
CREATE POLICY "Users can create resumes in their organization" ON resumes
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());

-- Users can update resumes in their organization
CREATE POLICY "Users can update resumes in their organization" ON resumes
    FOR UPDATE USING (organization_id = get_user_organization_id());

-- Admins can delete resumes in their organization
CREATE POLICY "Admins can delete resumes in their organization" ON resumes
    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Match results policies
-- Users can view match results in their organization
CREATE POLICY "Users can view match results in their organization" ON match_results
    FOR SELECT USING (organization_id = get_user_organization_id());

-- System can create match results (for AI processing)
CREATE POLICY "System can create match results" ON match_results
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());

-- Users can update match results in their organization (for manual adjustments)
CREATE POLICY "Users can update match results in their organization" ON match_results
    FOR UPDATE USING (organization_id = get_user_organization_id());

-- Admins can delete match results in their organization
CREATE POLICY "Admins can delete match results in their organization" ON match_results
    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Job applications policies
-- Users can view job applications in their organization
CREATE POLICY "Users can view job applications in their organization" ON job_applications
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Users can create job applications in their organization
CREATE POLICY "Users can create job applications in their organization" ON job_applications
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());

-- Users can update job applications in their organization
CREATE POLICY "Users can update job applications in their organization" ON job_applications
    FOR UPDATE USING (organization_id = get_user_organization_id());

-- Admins can delete job applications in their organization
CREATE POLICY "Admins can delete job applications in their organization" ON job_applications
    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Create a function to handle user registration
-- This function should be called when a new user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- This function will be called by the auth.users trigger
    -- The actual organization assignment should be handled by the application
    -- when the user completes their profile setup
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user registration
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Create a function to get organization statistics (for dashboard)
CREATE OR REPLACE FUNCTION get_organization_stats(org_id UUID)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    -- Only allow users to get stats for their own organization
    IF org_id != get_user_organization_id() THEN
        RAISE EXCEPTION 'Access denied: Cannot access other organization data';
    END IF;
    
    SELECT json_build_object(
        'total_jobs', (SELECT COUNT(*) FROM jobs WHERE organization_id = org_id),
        'active_jobs', (SELECT COUNT(*) FROM jobs WHERE organization_id = org_id AND status = 'active'),
        'total_candidates', (SELECT COUNT(*) FROM candidates WHERE organization_id = org_id),
        'total_resumes', (SELECT COUNT(*) FROM resumes WHERE organization_id = org_id),
        'total_matches', (SELECT COUNT(*) FROM match_results WHERE organization_id = org_id),
        'avg_match_score', (SELECT ROUND(AVG(match_score), 2) FROM match_results WHERE organization_id = org_id)
    ) INTO result;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Subscription plans policies
-- Subscription plans are public data that all users can view
CREATE POLICY "Anyone can view subscription plans" ON subscription_plans
    FOR SELECT USING (is_active = true);

-- Only admins can manage subscription plans (for system administration)
CREATE POLICY "Admins can manage subscription plans" ON subscription_plans
    FOR ALL USING (is_user_admin());

-- Subscriptions policies
-- Users can view their organization's subscription
CREATE POLICY "Users can view their organization subscription" ON subscriptions
    FOR SELECT USING (organization_id = get_user_organization_id());

-- Only admins can update their organization's subscription
CREATE POLICY "Admins can update their organization subscription" ON subscriptions
    FOR UPDATE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Only admins can create subscriptions for their organization
CREATE POLICY "Admins can create subscriptions for their organization" ON subscriptions
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id() AND is_user_admin());

-- Subscription usage policies
-- Users can view their organization's usage data
CREATE POLICY "Users can view their organization usage" ON subscription_usage
    FOR SELECT USING (organization_id = get_user_organization_id());

-- System can create usage records (for automated tracking)
CREATE POLICY "System can create usage records" ON subscription_usage
    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());

-- Only admins can update usage records
CREATE POLICY "Admins can update usage records" ON subscription_usage
    FOR UPDATE USING (organization_id = get_user_organization_id() AND is_user_admin());

-- Grant necessary permissions
-- Note: In a real Supabase setup, these would be handled by the service role
-- This is just for reference of what permissions are needed

-- Allow authenticated users to use the helper functions
GRANT EXECUTE ON FUNCTION get_user_organization_id() TO authenticated;
GRANT EXECUTE ON FUNCTION is_user_admin() TO authenticated;
GRANT EXECUTE ON FUNCTION get_organization_stats(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION get_organization_current_subscription(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION check_organization_limits(UUID) TO authenticated;


-- Resumes policies

-- Users can view resumes in their organization

CREATE POLICY "Users can view resumes in their organization" ON resumes

    FOR SELECT USING (organization_id = get_user_organization_id());



-- Users can create resumes in their organization

CREATE POLICY "Users can create resumes in their organization" ON resumes

    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());



-- Users can update resumes in their organization

CREATE POLICY "Users can update resumes in their organization" ON resumes

    FOR UPDATE USING (organization_id = get_user_organization_id());



-- Admins can delete resumes in their organization

CREATE POLICY "Admins can delete resumes in their organization" ON resumes

    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());



-- Match results policies

-- Users can view match results in their organization

CREATE POLICY "Users can view match results in their organization" ON match_results

    FOR SELECT USING (organization_id = get_user_organization_id());



-- System can create match results (for AI processing)

CREATE POLICY "System can create match results" ON match_results

    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());



-- Users can update match results in their organization (for manual adjustments)

CREATE POLICY "Users can update match results in their organization" ON match_results

    FOR UPDATE USING (organization_id = get_user_organization_id());



-- Admins can delete match results in their organization

CREATE POLICY "Admins can delete match results in their organization" ON match_results

    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());



-- Job applications policies

-- Users can view job applications in their organization

CREATE POLICY "Users can view job applications in their organization" ON job_applications

    FOR SELECT USING (organization_id = get_user_organization_id());



-- Users can create job applications in their organization

CREATE POLICY "Users can create job applications in their organization" ON job_applications

    FOR INSERT WITH CHECK (organization_id = get_user_organization_id());



-- Users can update job applications in their organization

CREATE POLICY "Users can update job applications in their organization" ON job_applications

    FOR UPDATE USING (organization_id = get_user_organization_id());



-- Admins can delete job applications in their organization

CREATE POLICY "Admins can delete job applications in their organization" ON job_applications

    FOR DELETE USING (organization_id = get_user_organization_id() AND is_user_admin());



-- Create a function to handle user registration

-- This function should be called when a new user signs up

CREATE OR REPLACE FUNCTION handle_new_user()

RETURNS TRIGGER AS $$

BEGIN

    -- This function will be called by the auth.users trigger

    -- The actual organization assignment should be handled by the application

    -- when the user completes their profile setup

    RETURN NEW;

END;

$$ LANGUAGE plpgsql SECURITY DEFINER;



-- Create trigger for new user registration

CREATE TRIGGER on_auth_user_created

    AFTER INSERT ON auth.users

    FOR EACH ROW EXECUTE FUNCTION handle_new_user();



-- Create a function to get organization statistics (for dashboard)

CREATE OR REPLACE FUNCTION get_organization_stats(org_id UUID)

RETURNS JSON AS $$

DECLARE

    result JSON;

BEGIN

    -- Only allow users to get stats for their own organization

    IF org_id != get_user_organization_id() THEN

        RAISE EXCEPTION 'Access denied: Cannot access other organization data';

    END IF;

    

    SELECT json_build_object(

        'total_jobs', (SELECT COUNT(*) FROM jobs WHERE organization_id = org_id),

        'active_jobs', (SELECT COUNT(*) FROM jobs WHERE organization_id = org_id AND status = 'active'),

        'total_candidates', (SELECT COUNT(*) FROM candidates WHERE organization_id = org_id),

        'total_resumes', (SELECT COUNT(*) FROM resumes WHERE organization_id = org_id),

        'total_matches', (SELECT COUNT(*) FROM match_results WHERE organization_id = org_id),

        'avg_match_score', (SELECT ROUND(AVG(match_score), 2) FROM match_results WHERE organization_id = org_id)

    ) INTO result;

    

    RETURN result;

END;

$$ LANGUAGE plpgsql SECURITY DEFINER;



-- Grant necessary permissions

-- Note: In a real Supabase setup, these would be handled by the service role

-- This is just for reference of what permissions are needed



-- Allow authenticated users to use the helper functions

GRANT EXECUTE ON FUNCTION get_user_organization_id() TO authenticated;

GRANT EXECUTE ON FUNCTION is_user_admin() TO authenticated;

GRANT EXECUTE ON FUNCTION get_organization_stats(UUID) TO authenticated;

