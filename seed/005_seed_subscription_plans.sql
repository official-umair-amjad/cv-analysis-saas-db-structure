-- Seed data for subscription plans and subscriptions
-- This file creates sample subscription plans and assigns them to organizations

-- Insert subscription plans
INSERT INTO subscription_plans (id, name, slug, description, price_monthly, price_yearly, currency, max_users, max_jobs_per_month, max_candidates, max_storage_gb, features, is_active) VALUES
(
    '550e8400-e29b-41d4-a716-446655440010',
    'Free',
    'free',
    'Perfect for small teams getting started with recruitment',
    0.00,
    0.00,
    'USD',
    5,
    10,
    100,
    1,
    '{"ai_matching": true, "basic_analytics": true, "email_support": true, "api_access": false, "custom_branding": false, "advanced_analytics": false}',
    true
),
(
    '550e8400-e29b-41d4-a716-446655440011',
    'Basic',
    'basic',
    'Ideal for growing recruitment teams',
    29.00,
    290.00,
    'USD',
    10,
    50,
    500,
    10,
    '{"ai_matching": true, "basic_analytics": true, "email_support": true, "api_access": true, "custom_branding": false, "advanced_analytics": false, "priority_support": false}',
    true
),
(
    '550e8400-e29b-41d4-a716-446655440012',
    'Premium',
    'premium',
    'Advanced features for established recruitment agencies',
    99.00,
    990.00,
    'USD',
    50,
    200,
    2000,
    50,
    '{"ai_matching": true, "basic_analytics": true, "email_support": true, "api_access": true, "custom_branding": true, "advanced_analytics": true, "priority_support": true, "white_label": false}',
    true
),
(
    '550e8400-e29b-41d4-a716-446655440013',
    'Enterprise',
    'enterprise',
    'Full-featured solution for large organizations',
    299.00,
    2990.00,
    'USD',
    200,
    1000,
    10000,
    200,
    '{"ai_matching": true, "basic_analytics": true, "email_support": true, "api_access": true, "custom_branding": true, "advanced_analytics": true, "priority_support": true, "white_label": true, "dedicated_support": true, "sla": true}',
    true
);

-- Insert subscriptions for existing organizations
INSERT INTO subscriptions (id, organization_id, plan_id, status, billing_cycle, current_period_start, current_period_end, trial_start, trial_end, stripe_subscription_id, stripe_customer_id) VALUES
-- TechCorp Solutions - Premium plan
(
    '550e8400-e29b-41d4-a716-446655440020',
    '550e8400-e29b-41d4-a716-446655440001',
    '550e8400-e29b-41d4-a716-446655440012',
    'active',
    'monthly',
    CURRENT_DATE - INTERVAL '15 days',
    CURRENT_DATE + INTERVAL '15 days',
    CURRENT_DATE - INTERVAL '45 days',
    CURRENT_DATE - INTERVAL '15 days',
    'sub_techcorp_premium_monthly',
    'cus_techcorp_solutions'
),
-- StartupXYZ - Basic plan
(
    '550e8400-e29b-41d4-a716-446655440021',
    '550e8400-e29b-41d4-a716-446655440002',
    '550e8400-e29b-41d4-a716-446655440011',
    'active',
    'yearly',
    CURRENT_DATE - INTERVAL '30 days',
    CURRENT_DATE + INTERVAL '335 days',
    CURRENT_DATE - INTERVAL '60 days',
    CURRENT_DATE - INTERVAL '30 days',
    'sub_startupxyz_basic_yearly',
    'cus_startupxyz'
),
-- Global Recruiters Inc - Enterprise plan
(
    '550e8400-e29b-41d4-a716-446655440022',
    '550e8400-e29b-41d4-a716-446655440003',
    '550e8400-e29b-41d4-a716-446655440013',
    'active',
    'yearly',
    CURRENT_DATE - INTERVAL '60 days',
    CURRENT_DATE + INTERVAL '305 days',
    NULL,
    NULL,
    'sub_global_enterprise_yearly',
    'cus_global_recruiters'
),
-- Small Agency Co - Free plan
(
    '550e8400-e29b-41d4-a716-446655440023',
    '550e8400-e29b-41d4-a716-446655440004',
    '550e8400-e29b-41d4-a716-446655440010',
    'active',
    'monthly',
    CURRENT_DATE - INTERVAL '10 days',
    CURRENT_DATE + INTERVAL '20 days',
    CURRENT_DATE - INTERVAL '40 days',
    CURRENT_DATE - INTERVAL '10 days',
    NULL,
    NULL
);

-- Insert sample usage data for the current month
INSERT INTO subscription_usage (id, subscription_id, organization_id, usage_date, users_count, jobs_created_count, candidates_added_count, storage_used_mb, api_calls_count) VALUES
-- TechCorp Solutions usage
(
    '550e8400-e29b-41d4-a716-446655440030',
    '550e8400-e29b-41d4-a716-446655440020',
    '550e8400-e29b-41d4-a716-446655440001',
    CURRENT_DATE,
    3,
    2,
    3,
    15,
    150
),
-- StartupXYZ usage
(
    '550e8400-e29b-41d4-a716-446655440031',
    '550e8400-e29b-41d4-a716-446655440021',
    '550e8400-e29b-41d4-a716-446655440002',
    CURRENT_DATE,
    2,
    1,
    1,
    8,
    75
),
-- Global Recruiters Inc usage
(
    '550e8400-e29b-41d4-a716-446655440032',
    '550e8400-e29b-41d4-a716-446655440022',
    '550e8400-e29b-41d4-a716-446655440003',
    CURRENT_DATE,
    3,
    1,
    1,
    25,
    200
),
-- Small Agency Co usage
(
    '550e8400-e29b-41d4-a716-446655440033',
    '550e8400-e29b-41d4-a716-446655440023',
    '550e8400-e29b-41d4-a716-446655440004',
    CURRENT_DATE,
    2,
    0,
    0,
    5,
    25
);

-- Update organizations table to reference current subscriptions
UPDATE organizations SET 
    current_subscription_id = '550e8400-e29b-41d4-a716-446655440020',
    subscription_status = 'active'
WHERE id = '550e8400-e29b-41d4-a716-446655440001';

UPDATE organizations SET 
    current_subscription_id = '550e8400-e29b-41d4-a716-446655440021',
    subscription_status = 'active'
WHERE id = '550e8400-e29b-41d4-a716-446655440002';

UPDATE organizations SET 
    current_subscription_id = '550e8400-e29b-41d4-a716-446655440022',
    subscription_status = 'active'
WHERE id = '550e8400-e29b-41d4-a716-446655440003';

UPDATE organizations SET 
    current_subscription_id = '550e8400-e29b-41d4-a716-446655440023',
    subscription_status = 'active'
WHERE id = '550e8400-e29b-41d4-a716-446655440004';
