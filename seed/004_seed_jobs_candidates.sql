-- Seed data for jobs, candidates, resumes, and match results
-- This file creates sample data to demonstrate the recruitment system functionality
-- All UUIDs use valid hexadecimal characters (0-9, a-f)

-- Insert sample jobs
INSERT INTO jobs (id, organization_id, created_by, title, description, requirements, location, employment_type, salary_min, salary_max, currency, status) VALUES
-- TechCorp Solutions jobs
(
    '11111111-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    '11111111-1111-1111-1111-111111111111',
    'Senior Full Stack Developer',
    'We are looking for an experienced full-stack developer to join our growing team. You will be responsible for developing and maintaining our web applications using modern technologies.',
    '5+ years experience with React, Node.js, PostgreSQL, AWS, Docker, Git',
    'San Francisco, CA (Remote)',
    'full-time',
    120000,
    160000,
    'USD',
    'active'
),
(
    '11111111-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    '11111111-1111-1111-1111-111111111112',
    'DevOps Engineer',
    'Join our infrastructure team to help scale our platform. You will work with cloud technologies, CI/CD pipelines, and monitoring systems.',
    '3+ years experience with AWS, Kubernetes, Terraform, Jenkins, Python',
    'New York, NY',
    'full-time',
    100000,
    140000,
    'USD',
    'active'
),

-- StartupXYZ jobs
(
    '22222222-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    '22222222-2222-2222-2222-222222222221',
    'Frontend Developer',
    'We need a creative frontend developer to help build our user-facing applications. You will work closely with our design team.',
    '2+ years experience with React, TypeScript, CSS, Figma',
    'Austin, TX',
    'full-time',
    80000,
    110000,
    'USD',
    'active'
),

-- Global Recruiters Inc jobs
(
    '33333333-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    '33333333-3333-3333-3333-333333333331',
    'Data Scientist',
    'Looking for a data scientist to join our analytics team. You will work on machine learning models and data analysis projects.',
    'PhD in Data Science or 3+ years experience with Python, TensorFlow, SQL, Statistics',
    'London, UK',
    'full-time',
    90000,
    130000,
    'GBP',
    'active'
);

-- Insert sample candidates
INSERT INTO candidates (id, organization_id, email, first_name, last_name, phone, location, linkedin_url, source) VALUES
-- TechCorp Solutions candidates
(
    'aaaaaaaa-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    'alice.martinez@email.com',
    'Alice',
    'Martinez',
    '+1-555-0101',
    'San Francisco, CA',
    'https://linkedin.com/in/alicemartinez',
    'linkedin'
),
(
    'aaaaaaaa-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'bob.thompson@email.com',
    'Bob',
    'Thompson',
    '+1-555-0102',
    'Seattle, WA',
    'https://linkedin.com/in/bobthompson',
    'indeed'
),
(
    'aaaaaaaa-1111-1111-1111-111111111113',
    '550e8400-e29b-41d4-a716-446655440001',
    'carol.white@email.com',
    'Carol',
    'White',
    '+1-555-0103',
    'New York, NY',
    'https://linkedin.com/in/carolwhite',
    'referral'
),

-- StartupXYZ candidates
(
    'bbbbbbbb-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    'david.lee@email.com',
    'David',
    'Lee',
    '+1-555-0201',
    'Austin, TX',
    'https://linkedin.com/in/davidlee',
    'linkedin'
),

-- Global Recruiters Inc candidates
(
    'cccccccc-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    'eve.brown@email.com',
    'Eve',
    'Brown',
    '+44-20-7946-0958',
    'London, UK',
    'https://linkedin.com/in/evebrown',
    'linkedin'
);

-- Insert sample resumes
INSERT INTO resumes (id, candidate_id, organization_id, file_name, file_path, file_size, file_type, content_hash, raw_text, processing_status) VALUES
-- TechCorp Solutions resumes
(
    'dddddddd-1111-1111-1111-111111111111',
    'aaaaaaaa-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    'Alice_Martinez_Resume.pdf',
    'resumes/techcorp/alice_martinez_resume.pdf',
    245760,
    'application/pdf',
    'a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456',
    'Alice Martinez Senior Software Engineer 5+ years experience in full-stack development. Proficient in React, Node.js, PostgreSQL, AWS. Led development of e-commerce platform serving 100k+ users.',
    'completed'
),
(
    'dddddddd-1111-1111-1111-111111111112',
    'aaaaaaaa-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'Bob_Thompson_Resume.pdf',
    'resumes/techcorp/bob_thompson_resume.pdf',
    198432,
    'application/pdf',
    'b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234567',
    'Bob Thompson DevOps Engineer 4+ years experience in cloud infrastructure and automation. Expert in AWS, Kubernetes, Docker, CI/CD pipelines. Reduced deployment time by 60%.',
    'completed'
),
(
    'dddddddd-1111-1111-1111-111111111113',
    'aaaaaaaa-1111-1111-1111-111111111113',
    '550e8400-e29b-41d4-a716-446655440001',
    'Carol_White_Resume.pdf',
    'resumes/techcorp/carol_white_resume.pdf',
    312456,
    'application/pdf',
    'c3d4e5f6789012345678901234567890abcdef1234567890abcdef12345678',
    'Carol White Full Stack Developer 6+ years experience building scalable web applications. Strong background in React, Python, Django, PostgreSQL. Led team of 5 developers.',
    'completed'
),

-- StartupXYZ resumes
(
    'eeeeeeee-2222-2222-2222-222222222221',
    'bbbbbbbb-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    'David_Lee_Resume.pdf',
    'resumes/startupxyz/david_lee_resume.pdf',
    187654,
    'application/pdf',
    'd4e5f6789012345678901234567890abcdef1234567890abcdef123456789',
    'David Lee Frontend Developer 3+ years experience in React, TypeScript, and modern CSS. Passionate about creating beautiful user interfaces. Experience with Figma and design systems.',
    'completed'
),

-- Global Recruiters Inc resumes
(
    'ffffffff-3333-3333-3333-333333333331',
    'cccccccc-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    'Eve_Brown_Resume.pdf',
    'resumes/global/eve_brown_resume.pdf',
    267890,
    'application/pdf',
    'e5f6789012345678901234567890abcdef1234567890abcdef1234567890',
    'Eve Brown Data Scientist PhD in Computer Science with 4+ years experience in machine learning and data analysis. Expert in Python, TensorFlow, PyTorch, SQL. Published 8 research papers.',
    'completed'
);

-- Insert sample match results
INSERT INTO match_results (id, job_id, candidate_id, resume_id, organization_id, match_score, skills_match_score, experience_match_score, education_match_score, ai_summary, strengths, concerns, recommendations, processing_model) VALUES
-- TechCorp Solutions match results
(
    'aaaaaaaa-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-1111-1111-1111-111111111111',
    'dddddddd-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    92.5,
    95.0,
    90.0,
    90.0,
    'Alice Martinez is an excellent match for the Senior Full Stack Developer position. She has 5+ years of relevant experience with all the required technologies including React, Node.js, PostgreSQL, and AWS. Her experience leading development of a large-scale e-commerce platform demonstrates her ability to handle complex systems and work with large user bases.',
    ARRAY['Strong React and Node.js experience', 'AWS cloud experience', 'Leadership experience', 'E-commerce platform development'],
    ARRAY['No specific mention of Docker experience', 'Could benefit from more DevOps knowledge'],
    'Highly recommended for interview. Alice has the technical skills and leadership experience needed for this senior role. Consider discussing her Docker experience and interest in DevOps practices.',
    'gpt-4-turbo'
),
(
    'aaaaaaaa-1111-1111-1111-111111111112',
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-1111-1111-1111-111111111112',
    'dddddddd-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    78.0,
    70.0,
    85.0,
    80.0,
    'Bob Thompson is a good match for the Senior Full Stack Developer position, though his primary strength is in DevOps rather than full-stack development. He has strong AWS and infrastructure experience but limited frontend development experience.',
    ARRAY['Strong AWS and cloud experience', 'DevOps and automation skills', 'CI/CD pipeline experience'],
    ARRAY['Limited frontend development experience', 'More focused on infrastructure than application development'],
    'Consider for interview if looking for someone with strong DevOps skills who can grow into full-stack development. May be better suited for a DevOps-focused role.',
    'gpt-4-turbo'
),
(
    'aaaaaaaa-1111-1111-1111-111111111113',
    '11111111-1111-1111-1111-111111111112',
    'aaaaaaaa-1111-1111-1111-111111111112',
    'dddddddd-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    95.0,
    98.0,
    92.0,
    95.0,
    'Bob Thompson is an exceptional match for the DevOps Engineer position. He has extensive experience with all the required technologies including AWS, Kubernetes, Terraform, and Jenkins. His track record of reducing deployment time by 60% demonstrates his effectiveness in this role.',
    ARRAY['Expert-level AWS knowledge', 'Kubernetes and containerization experience', 'Terraform infrastructure as code', 'Proven track record of improving deployment processes'],
    ARRAY['None identified'],
    'Strongly recommended for immediate interview. Bob is an ideal candidate for this DevOps role with all required skills and proven results.',
    'gpt-4-turbo'
),

-- StartupXYZ match results
(
    'bbbbbbbb-2222-2222-2222-222222222221',
    '22222222-2222-2222-2222-222222222221',
    'bbbbbbbb-2222-2222-2222-222222222221',
    'eeeeeeee-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    88.0,
    90.0,
    85.0,
    90.0,
    'David Lee is a strong match for the Frontend Developer position. He has 3+ years of relevant experience with React and TypeScript, and his passion for creating beautiful user interfaces aligns well with the role requirements. His experience with Figma and design systems is a valuable addition.',
    ARRAY['Strong React and TypeScript skills', 'Design system experience', 'Figma proficiency', 'Passion for UI/UX'],
    ARRAY['Limited backend experience', 'Could benefit from more testing experience'],
    'Recommended for interview. David has the core frontend skills needed and shows enthusiasm for design, which is valuable for a startup environment.',
    'gpt-4-turbo'
),

-- Global Recruiters Inc match results
(
    'cccccccc-3333-3333-3333-333333333331',
    '33333333-3333-3333-3333-333333333331',
    'cccccccc-3333-3333-3333-333333333331',
    'ffffffff-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    96.0,
    98.0,
    95.0,
    100.0,
    'Eve Brown is an outstanding match for the Data Scientist position. She has a PhD in Computer Science and 4+ years of relevant experience with all the required technologies. Her research background and publication record demonstrate deep expertise in machine learning and data analysis.',
    ARRAY['PhD in Computer Science', 'Expert-level Python and ML frameworks', 'Strong research background', 'Published research papers', 'Comprehensive SQL skills'],
    ARRAY['None identified'],
    'Highly recommended for immediate interview. Eve is an exceptional candidate with the perfect combination of academic credentials and practical experience.',
    'gpt-4-turbo'
);

-- Insert sample job applications
INSERT INTO job_applications (id, job_id, candidate_id, resume_id, organization_id, application_status, applied_at) VALUES
-- TechCorp Solutions applications
(
    'dddddddd-1111-1111-1111-111111111111',
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-1111-1111-1111-111111111111',
    'dddddddd-1111-1111-1111-111111111111',
    '550e8400-e29b-41d4-a716-446655440001',
    'shortlisted',
    NOW() - INTERVAL '2 days'
),
(
    'dddddddd-1111-1111-1111-111111111112',
    '11111111-1111-1111-1111-111111111111',
    'aaaaaaaa-1111-1111-1111-111111111112',
    'dddddddd-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'reviewing',
    NOW() - INTERVAL '1 day'
),
(
    'dddddddd-1111-1111-1111-111111111113',
    '11111111-1111-1111-1111-111111111112',
    'aaaaaaaa-1111-1111-1111-111111111112',
    'dddddddd-1111-1111-1111-111111111112',
    '550e8400-e29b-41d4-a716-446655440001',
    'shortlisted',
    NOW() - INTERVAL '3 days'
),

-- StartupXYZ applications
(
    'eeeeeeee-2222-2222-2222-222222222221',
    '22222222-2222-2222-2222-222222222221',
    'bbbbbbbb-2222-2222-2222-222222222221',
    'eeeeeeee-2222-2222-2222-222222222221',
    '550e8400-e29b-41d4-a716-446655440002',
    'reviewing',
    NOW() - INTERVAL '1 day'
),

-- Global Recruiters Inc applications
(
    'ffffffff-3333-3333-3333-333333333331',
    '33333333-3333-3333-3333-333333333331',
    'cccccccc-3333-3333-3333-333333333331',
    'ffffffff-3333-3333-3333-333333333331',
    '550e8400-e29b-41d4-a716-446655440003',
    'shortlisted',
    NOW() - INTERVAL '2 days'
);
