-- Seed data for user profiles
-- This file creates sample user profiles for testing
-- IMPORTANT: This seed file should only be run AFTER creating corresponding users in Supabase Auth

-- First, let's create a function to safely insert user profiles
-- This function will check if the auth user exists before inserting the profile
CREATE OR REPLACE FUNCTION create_user_profile_safe(
    user_id UUID,
    org_id UUID,
    user_email TEXT,
    first_name TEXT,
    last_name TEXT,
    user_role TEXT DEFAULT 'recruiter'
) RETURNS BOOLEAN AS $$
BEGIN
    -- Check if the auth user exists
    IF NOT EXISTS (SELECT 1 FROM auth.users WHERE id = user_id) THEN
        RAISE WARNING 'Auth user % does not exist. Skipping user profile creation.', user_id;
        RETURN FALSE;
    END IF;
    
    -- Check if the organization exists
    IF NOT EXISTS (SELECT 1 FROM organizations WHERE id = org_id) THEN
        RAISE WARNING 'Organization % does not exist. Skipping user profile creation.', org_id;
        RETURN FALSE;
    END IF;
    
    -- Insert the user profile
    INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role, is_active)
    VALUES (user_id, org_id, user_email, first_name, last_name, user_role, true);
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Now create user profiles using the safe function
-- TechCorp Solutions users
SELECT create_user_profile_safe(
    '11111111-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    'admin@techcorp.com',
    'John',
    'Smith',
    'admin'
);

SELECT create_user_profile_safe(
    '11111111-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'sarah.johnson@techcorp.com',
    'Sarah',
    'Johnson',
    'recruiter'
);

SELECT create_user_profile_safe(
    '11111111-1111-1111-1111-111111111113',
    '550e8400-e29b-41d4-a716-446655440001',
    'mike.chen@techcorp.com',
    'Mike',
    'Chen',
    'recruiter'
);

-- StartupXYZ users
SELECT create_user_profile_safe(
    '22222222-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    'ceo@startupxyz.io',
    'Alex',
    'Rodriguez',
    'admin'
);

SELECT create_user_profile_safe(
    '22222222-2222-2222-2222-222222222222',
    '550e8400-e29b-41d4-a716-446655440002',
    'hr@startupxyz.io',
    'Emma',
    'Wilson',
    'recruiter'
);

-- Global Recruiters Inc users
SELECT create_user_profile_safe(
    '33333333-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    'director@globalrecruiters.com',
    'David',
    'Brown',
    'admin'
);

SELECT create_user_profile_safe(
    '33333333-3333-3333-3333-333333333332',
    '550e8400-e29b-41d4-a716-446655440003',
    'senior.recruiter@globalrecruiters.com',
    'Lisa',
    'Garcia',
    'recruiter'
);

SELECT create_user_profile_safe(
    '33333333-3333-3333-3333-333333333333',
    '550e8400-e29b-41d4-a716-446655440003',
    'junior.recruiter@globalrecruiters.com',
    'Tom',
    'Anderson',
    'recruiter'
);

-- Small Agency Co users
SELECT create_user_profile_safe(
    '44444444-4444-4444-4444-444444444441',
    '550e8400-e29b-41d4-a716-446655440004',
    'owner@smallagency.co',
    'Jennifer',
    'Davis',
    'admin'
);

SELECT create_user_profile_safe(
    '44444444-4444-4444-4444-444444444442',
    '550e8400-e29b-41d4-a716-446655440004',
    'recruiter@smallagency.co',
    'Robert',
    'Taylor',
    'recruiter'
);

-- Clean up the helper function
DROP FUNCTION create_user_profile_safe(UUID, UUID, TEXT, TEXT, TEXT, TEXT);

-- Note: To create the corresponding auth.users entries, you can:
-- 1. Use the Supabase Dashboard: Authentication > Users > Add User
-- 2. Use the Supabase Auth API
-- 3. Use the Supabase CLI: supabase auth users create
-- 4. Use the SQL below (if you have the necessary permissions)
