-- Alternative seed data for user profiles (without auth.users dependency)
-- This file creates sample user profiles for testing WITHOUT requiring auth.users entries
-- Use this file if you want to test the schema without setting up authentication

-- Temporarily disable the foreign key constraint to auth.users
-- This allows us to insert user profiles without corresponding auth users
ALTER TABLE user_profiles DROP CONSTRAINT IF EXISTS user_profiles_id_fkey;

-- Insert sample user profiles
-- TechCorp Solutions users
INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role, is_active) VALUES
(
    '11111111-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    'admin@techcorp.com',
    'John',
    'Smith',
    'admin',
    true
),
(
    '11111111-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'sarah.johnson@techcorp.com',
    'Sarah',
    'Johnson',
    'recruiter',
    true
),
(
    '11111111-1111-1111-1111-111111111113',
    '550e8400-e29b-41d4-a716-446655440001',
    'mike.chen@techcorp.com',
    'Mike',
    'Chen',
    'recruiter',
    true
);

-- StartupXYZ users
INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role, is_active) VALUES
(
    '22222222-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    'ceo@startupxyz.io',
    'Alex',
    'Rodriguez',
    'admin',
    true
),
(
    '22222222-2222-2222-2222-222222222222',
    '550e8400-e29b-41d4-a716-446655440002',
    'hr@startupxyz.io',
    'Emma',
    'Wilson',
    'recruiter',
    true
);

-- Global Recruiters Inc users
INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role, is_active) VALUES
(
    '33333333-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    'director@globalrecruiters.com',
    'David',
    'Brown',
    'admin',
    true
),
(
    '33333333-3333-3333-3333-333333333332',
    '550e8400-e29b-41d4-a716-446655440003',
    'senior.recruiter@globalrecruiters.com',
    'Lisa',
    'Garcia',
    'recruiter',
    true
),
(
    '33333333-3333-3333-3333-333333333333',
    '550e8400-e29b-41d4-a716-446655440003',
    'junior.recruiter@globalrecruiters.com',
    'Tom',
    'Anderson',
    'recruiter',
    true
);

-- Small Agency Co users
INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role, is_active) VALUES
(
    '44444444-4444-4444-4444-444444444441',
    '550e8400-e29b-41d4-a716-446655440004',
    'owner@smallagency.co',
    'Jennifer',
    'Davis',
    'admin',
    true
),
(
    '44444444-4444-4444-4444-444444444442',
    '550e8400-e29b-41d4-a716-446655440004',
    'recruiter@smallagency.co',
    'Robert',
    'Taylor',
    'recruiter',
    true
);

-- Re-enable the foreign key constraint
-- Note: This will fail if you don't have corresponding auth.users entries
-- ALTER TABLE user_profiles ADD CONSTRAINT user_profiles_id_fkey 
--     FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- Note: This file is for testing purposes only
-- In production, you should use the proper authentication flow and the original seed file
