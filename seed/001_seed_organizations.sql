-- Seed data for organizations
-- This file creates sample organizations for testing the multi-tenant system

-- Insert sample organizations
INSERT INTO organizations (id, name, slug, domain, subscription_tier, max_users, max_jobs_per_month) VALUES
(
    '550e8400-e29b-41d4-a716-446655440001',
    'TechCorp Solutions',
    'techcorp-solutions',
    'techcorp.com',
    'premium',
    50,
    100
),
(
    '550e8400-e29b-41d4-a716-446655440002',
    'StartupXYZ',
    'startupxyz',
    'startupxyz.io',
    'basic',
    10,
    25
),
(
    '550e8400-e29b-41d4-a716-446655440003',
    'Global Recruiters Inc',
    'global-recruiters',
    'globalrecruiters.com',
    'enterprise',
    200,
    1000
),
(
    '550e8400-e29b-41d4-a716-446655440004',
    'Small Agency Co',
    'small-agency',
    'smallagency.co',
    'free',
    5,
    10
);

-- Note: In a real Supabase setup, you would also need to create corresponding auth.users
-- entries. This is typically handled by the Supabase Auth system when users sign up.
-- For testing purposes, you might want to create test users manually or use the Supabase dashboard.
