-- Create auth users for testing
-- This file creates the necessary auth.users entries for the seed data
-- IMPORTANT: This requires elevated permissions and should be run with caution

-- Note: In a production environment, users would be created through:
-- 1. Supabase Dashboard: Authentication > Users > Add User
-- 2. Supabase Auth API
-- 3. User registration flow
-- 4. Supabase CLI: supabase auth users create

-- This file is provided for testing purposes only
-- Run this ONLY if you have the necessary permissions to insert into auth.users

-- TechCorp Solutions users
INSERT INTO auth.users (
    id,
    instance_id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    recovery_sent_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES
(
    '11111111-1111-1111-1111-111111111111',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'admin@techcorp.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "John", "last_name": "Smith"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '11111111-1111-1111-1111-111111111112',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'sarah.johnson@techcorp.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Sarah", "last_name": "Johnson"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '11111111-1111-1111-1111-111111111113',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'mike.chen@techcorp.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Mike", "last_name": "Chen"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),

-- StartupXYZ users
(
    '22222222-2222-2222-2222-222222222221',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'ceo@startupxyz.io',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Alex", "last_name": "Rodriguez"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '22222222-2222-2222-2222-222222222222',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'hr@startupxyz.io',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Emma", "last_name": "Wilson"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),

-- Global Recruiters Inc users
(
    '33333333-3333-3333-3333-333333333331',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'director@globalrecruiters.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "David", "last_name": "Brown"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '33333333-3333-3333-3333-333333333332',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'senior.recruiter@globalrecruiters.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Lisa", "last_name": "Garcia"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '33333333-3333-3333-3333-333333333333',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'junior.recruiter@globalrecruiters.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Tom", "last_name": "Anderson"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),

-- Small Agency Co users
(
    '44444444-4444-4444-4444-444444444441',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'owner@smallagency.co',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Jennifer", "last_name": "Davis"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
),
(
    '44444444-4444-4444-4444-444444444442',
    '00000000-0000-0000-0000-000000000000',
    'authenticated',
    'authenticated',
    'recruiter@smallagency.co',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NULL,
    NOW(),
    '{"provider": "email", "providers": ["email"]}',
    '{"first_name": "Robert", "last_name": "Taylor"}',
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);

-- Note: All users have the password "password123" for testing purposes
-- In production, users would set their own passwords through the registration flow
