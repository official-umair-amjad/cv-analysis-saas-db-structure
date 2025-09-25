-- Test Query: Get all candidates for a single job with names and match scores
-- This query shows candidates who have applied to a specific job, along with their match results
-- Replace 'JOB_ID_HERE' with the actual job ID you want to test

-- Option 1: Get candidates with match results (recommended)
SELECT 
    j.title AS job_title,
    j.location AS job_location,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.location AS candidate_location,
    c.linkedin_url,
    c.source,
    mr.match_score,
    mr.skills_match_score,
    mr.experience_match_score,
    mr.education_match_score,
    mr.ai_summary,
    mr.strengths,
    mr.concerns,
    mr.recommendations,
    ja.application_status,
    ja.applied_at,
    r.file_name AS resume_file_name,
    r.processing_status AS resume_status,
    mr.created_at AS match_analyzed_at
FROM jobs j
JOIN job_applications ja ON j.id = ja.job_id
JOIN candidates c ON ja.candidate_id = c.id
LEFT JOIN resumes r ON ja.resume_id = r.id
LEFT JOIN match_results mr ON j.id = mr.job_id AND c.id = mr.candidate_id
WHERE j.id = '11111111-1111-1111-1111-111111111111'  -- Replace with actual job ID
ORDER BY 
    mr.match_score DESC NULLS LAST,
    ja.applied_at DESC;

-- Option 2: Get all candidates for a job (including those without match results)
SELECT 
    j.title AS job_title,
    j.location AS job_location,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.location AS candidate_location,
    c.linkedin_url,
    c.source,
    COALESCE(mr.match_score, 0) AS match_score,
    COALESCE(mr.skills_match_score, 0) AS skills_match_score,
    COALESCE(mr.experience_match_score, 0) AS experience_match_score,
    COALESCE(mr.education_match_score, 0) AS education_match_score,
    COALESCE(mr.ai_summary, 'No AI analysis available yet') AS ai_summary,
    mr.strengths,
    mr.concerns,
    mr.recommendations,
    ja.application_status,
    ja.applied_at,
    r.file_name AS resume_file_name,
    r.processing_status AS resume_status,
    mr.created_at AS match_analyzed_at,
    CASE 
        WHEN mr.match_score IS NULL THEN 'Pending Analysis'
        WHEN mr.match_score >= 90 THEN 'Excellent Match'
        WHEN mr.match_score >= 80 THEN 'Good Match'
        WHEN mr.match_score >= 70 THEN 'Fair Match'
        WHEN mr.match_score >= 60 THEN 'Poor Match'
        ELSE 'Very Poor Match'
    END AS match_rating
FROM jobs j
JOIN job_applications ja ON j.id = ja.job_id
JOIN candidates c ON ja.candidate_id = c.id
LEFT JOIN resumes r ON ja.resume_id = r.id
LEFT JOIN match_results mr ON j.id = mr.job_id AND c.id = mr.candidate_id
WHERE j.id = '11111111-1111-1111-1111-111111111111'  -- Replace with actual job ID
ORDER BY 
    mr.match_score DESC NULLS LAST,
    ja.applied_at DESC;

-- Option 3: Summary statistics for a job
SELECT 
    j.title AS job_title,
    j.location AS job_location,
    COUNT(DISTINCT ja.candidate_id) AS total_applications,
    COUNT(DISTINCT mr.candidate_id) AS candidates_analyzed,
    COUNT(DISTINCT CASE WHEN mr.match_score >= 80 THEN mr.candidate_id END) AS high_match_candidates,
    COUNT(DISTINCT CASE WHEN mr.match_score >= 70 AND mr.match_score < 80 THEN mr.candidate_id END) AS good_match_candidates,
    COUNT(DISTINCT CASE WHEN mr.match_score < 70 THEN mr.candidate_id END) AS low_match_candidates,
    ROUND(AVG(mr.match_score), 2) AS average_match_score,
    ROUND(MAX(mr.match_score), 2) AS highest_match_score,
    ROUND(MIN(mr.match_score), 2) AS lowest_match_score
FROM jobs j
LEFT JOIN job_applications ja ON j.id = ja.job_id
LEFT JOIN match_results mr ON j.id = mr.job_id
WHERE j.id = '11111111-1111-1111-1111-111111111111'  -- Replace with actual job ID
GROUP BY j.id, j.title, j.location;

-- Option 4: Get top candidates for a job (top 5 by match score)
SELECT 
    j.title AS job_title,
    c.first_name,
    c.last_name,
    c.email,
    c.location AS candidate_location,
    mr.match_score,
    mr.skills_match_score,
    mr.experience_match_score,
    mr.education_match_score,
    mr.ai_summary,
    mr.strengths,
    ja.application_status,
    ja.applied_at
FROM jobs j
JOIN match_results mr ON j.id = mr.job_id
JOIN candidates c ON mr.candidate_id = c.id
JOIN job_applications ja ON j.id = ja.job_id AND c.id = ja.candidate_id
WHERE j.id = '11111111-1111-1111-1111-111111111111'  -- Replace with actual job ID
ORDER BY mr.match_score DESC
LIMIT 5;

-- Test with sample data - Get candidates for "Senior Full Stack Developer" job
-- This uses the actual job ID from the seed data
SELECT 
    j.title AS job_title,
    j.location AS job_location,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,
    c.location AS candidate_location,
    c.linkedin_url,
    c.source,
    mr.match_score,
    mr.skills_match_score,
    mr.experience_match_score,
    mr.education_match_score,
    mr.ai_summary,
    mr.strengths,
    mr.concerns,
    mr.recommendations,
    ja.application_status,
    ja.applied_at,
    r.file_name AS resume_file_name,
    r.processing_status AS resume_status,
    mr.created_at AS match_analyzed_at,
    CASE 
        WHEN mr.match_score >= 90 THEN 'Excellent Match'
        WHEN mr.match_score >= 80 THEN 'Good Match'
        WHEN mr.match_score >= 70 THEN 'Fair Match'
        WHEN mr.match_score >= 60 THEN 'Poor Match'
        ELSE 'Very Poor Match'
    END AS match_rating
FROM jobs j
JOIN job_applications ja ON j.id = ja.job_id
JOIN candidates c ON ja.candidate_id = c.id
LEFT JOIN resumes r ON ja.resume_id = r.id
LEFT JOIN match_results mr ON j.id = mr.job_id AND c.id = mr.candidate_id
WHERE j.id = '11111111-1111-1111-1111-111111111111'  -- Senior Full Stack Developer job
ORDER BY 
    mr.match_score DESC NULLS LAST,
    ja.applied_at DESC;
