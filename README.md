# Multi-Tenant SaaS Recruitment Platform - Database Schema

This repository contains the database schema for a multi-tenant SaaS recruitment platform built with Supabase/PostgreSQL. The system allows recruitment companies to upload job descriptions and candidate CVs, then uses AI to match candidates to jobs with scoring and recommendations.

## 🏗️ Architecture Overview

The system is designed as a multi-tenant SaaS application with the following key features:

- **Multi-tenant isolation**: Each organization's data is completely isolated using Row Level Security (RLS)
- **Scalable design**: Supports organizations from small agencies to large enterprises
- **AI-powered matching**: Stores AI-generated match scores and recommendations
- **File management**: Handles CV/resume file storage and processing
- **Role-based access**: Different user roles (admin, recruiter, viewer) with appropriate permissions

## 📁 Project Structure

```
├── migrations/
│   ├── 001_create_tables.sql      # Core database tables
│   ├── 002_create_rls_policies.sql # Row Level Security policies
│   └── 003_create_subscription_table.sql # Subscription and billing tables
├── seed/
│   ├── 001_seed_organizations.sql  # Sample organizations
│   ├── 002_seed_users.sql         # Sample user profiles
│   ├── 002_seed_users_no_auth.sql # Sample users (testing version)
│   ├── 003_seed_jobs_candidates.sql # Sample jobs, candidates, and matches
│   ├── 004_create_auth_users.sql  # Auth users creation
│   └── 005_seed_subscription_plans.sql # Sample subscription plans and data
├── tests/
│   ├── test_schema.sql                # Schema validation and testing
│   ├── test_simple_rankings.sql       # Job rankings demonstration
brief
└── README.md                      # This file
```

## 🗄️ Database Schema

### Core Tables

1. **organizations** - Multi-tenant root table
   - Stores company information and subscription details
   - Each organization has its own data isolation

2. **user_profiles** - User management
   - Extends Supabase auth.users
   - Links users to their organization
   - Role-based permissions (admin, recruiter, viewer)

3. **jobs** - Job postings
   - Job descriptions and requirements
   - Status tracking (draft, active, paused, closed)
   - Salary and location information

4. **candidates** - Candidate information
   - Personal details and contact information
   - Source tracking (LinkedIn, Indeed, referral, etc.)

5. **resumes** - CV/Resume files
   - File storage metadata
   - Text extraction for AI processing
   - Deduplication using content hashing

6. **match_results** - AI matching results
   - Match scores (overall, skills, experience, education)
   - AI-generated summaries and recommendations
   - Strengths and concerns analysis

7. **job_applications** - Application tracking
   - Links candidates to jobs
   - Application status workflow
   - Review tracking

8. **subscription_plans** - Subscription plan definitions
   - Plan details (pricing, limits, features)
   - Feature flags and capabilities
   - Active/inactive status

9. **subscriptions** - Organization subscriptions
   - Links organizations to subscription plans
   - Billing cycle and status tracking
   - Trial periods and cancellation handling
   - Integration with external billing systems (Stripe)

10. **subscription_usage** - Usage tracking
    - Daily usage metrics per organization
    - User count, job creation, candidate additions
    - Storage and API usage tracking

### Key Features

- **UUID Primary Keys**: All tables use UUIDs for better security and scalability
- **Audit Trails**: Created/updated timestamps on all tables
- **Data Integrity**: Foreign key constraints and check constraints
- **Performance**: Strategic indexes for common query patterns
- **Security**: Comprehensive RLS policies for multi-tenant isolation

## 🔒 Security Model

### Row Level Security (RLS)

The system implements comprehensive RLS policies to ensure complete data isolation between organizations:

- **Organization Isolation**: Users can only access data from their own organization
- **Role-Based Access**: Different permissions for admins, recruiters, and viewers
- **Helper Functions**: Secure functions to get user organization and role information
- **Audit Functions**: Organization statistics and reporting functions

### Key Security Features

1. **Multi-tenant Isolation**: Complete data separation between organizations
2. **Role-based Permissions**: Granular access control based on user roles
3. **Secure Functions**: Helper functions with SECURITY DEFINER for safe access
4. **Audit Logging**: Built-in tracking of data changes and access

## 🚀 Deployment Instructions

### Prerequisites

- Supabase project set up
- Database access with appropriate permissions


### Option 2: Full Production Deployment

For production use with proper authentication:

#### Step 1: Run Migrations from folders mentioned

```sql
-- Run in Supabase SQL Editor or via CLI
\i migrations/001_create_tables.sql
\i migrations/002_create_rls_policies.sql
```

#### Step 2: Create Auth Users

Choose one of these methods:

**Method A: Using Supabase Dashboard (Recommended)**
1. Go to Supabase Dashboard → Authentication → Users
2. Create users with the UUIDs from the seed files
3. Set appropriate email addresses and passwords

**Method B: Using SQL (Requires elevated permissions)**
```sql
-- Run the auth users creation script
\i seed/004_create_auth_users.sql
```

#### Step 3: Seed Sample Data

```sql
-- Run seed files in order
\i seed/001_seed_organizations.sql
\i seed/002_seed_users.sql
\i seed/003_seed_jobs_candidates.sql
```

### Option 3: One-Command Deployment

```sql
-- Run the complete deployment script
\i deploy.sql
```

This will run everything in the correct order with proper error handling.

### Step 4: Test the Setup

Verify the setup by running some test queries:

```sql
-- Test organization isolation
SELECT * FROM organizations;

-- Test user profiles
SELECT up.*, o.name as organization_name 
FROM user_profiles up 
JOIN organizations o ON up.organization_id = o.id;

-- Test match results
SELECT 
    j.title as job_title,
    c.first_name || ' ' || c.last_name as candidate_name,
    mr.match_score,
    mr.ai_summary
FROM match_results mr
JOIN jobs j ON mr.job_id = j.id
JOIN candidates c ON mr.candidate_id = c.id
ORDER BY mr.match_score DESC;
```

## 🔧 Key Functions

### Helper Functions

- `get_user_organization_id()` - Returns current user's organization ID
- `is_user_admin()` - Checks if current user is an admin
- `get_organization_stats(org_id)` - Returns organization statistics
- `get_organization_current_subscription(org_id)` - Returns current subscription details
- `check_organization_limits(org_id)` - Checks if organization has exceeded subscription limits

### Usage Examples

```sql
-- Get current user's organization
SELECT get_user_organization_id();

-- Check if user is admin
SELECT is_user_admin();

-- Get organization statistics
SELECT get_organization_stats('550e8400-e29b-41d4-a716-446655440001');

-- Get current subscription details
SELECT * FROM get_organization_current_subscription('550e8400-e29b-41d4-a716-446655440001');

-- Check subscription limits
SELECT * FROM check_organization_limits('550e8400-e29b-41d4-a716-446655440001');
```

## 📊 Sample Data

The seed files include:

- **4 Organizations**: Different subscription tiers (free, basic, premium, enterprise)
- **10 Users**: Various roles across organizations
- **4 Jobs**: Different types of positions
- **5 Candidates**: With complete profiles and resumes
- **5 Match Results**: AI-generated scores and recommendations
- **5 Job Applications**: Various application statuses
- **4 Subscription Plans**: Free, Basic, Premium, and Enterprise tiers
- **4 Active Subscriptions**: Each organization has an active subscription
- **4 Usage Records**: Current month usage data for each organization

## 🎯 Use Cases

This schema supports:

1. **Multi-tenant SaaS**: Complete data isolation between organizations
2. **AI-powered Matching**: Store and query AI-generated match results
3. **File Management**: Handle CV/resume uploads and processing
4. **Application Tracking**: Full recruitment workflow management
5. **Analytics**: Organization-level statistics and reporting
6. **Scalability**: Designed to handle organizations of any size
7. **Subscription Management**: Flexible billing and plan management
8. **Usage Tracking**: Monitor resource consumption and enforce limits
9. **Billing Integration**: Ready for Stripe and other payment processors

## 🧪 Testing the Ranking System

The project includes two test files to demonstrate the job ranking functionality:

### Test Files Available:
- `test_schema.sql` - Comprehensive schema validation and testing
- `test_simple_rankings.sql` - Job rankings demonstration with candidate analysis

### How to Test the Ranking System:

#### Step 1: Deploy the Database Schema
1. **Option A: Quick Test (Recommended for testing)**
   ```sql
   -- Run in Supabase SQL Editor
   \i migrations/001_create_tables.sql
   \i migrations/002_create_rls_policies.sql
   \i migrations/003_create_subscription_table.sql
   \i seed/001_seed_organizations.sql
   \i seed/002_seed_users_no_auth.sql
   \i seed/003_seed_jobs_candidates.sql
   \i seed/005_seed_subscription_plans.sql
   ```

2. **Option B: Full Production Setup**
   ```sql
   -- Run in Supabase SQL Editor
   \i migrations/001_create_tables.sql
   \i migrations/002_create_rls_policies.sql
   \i migrations/003_create_subscription_table.sql
   \i seed/001_seed_organizations.sql
   \i seed/002_seed_users.sql
   \i seed/003_seed_jobs_candidates.sql
   \i seed/005_seed_subscription_plans.sql
   ```

#### Step 2: Test the Schema
```sql
-- Run the comprehensive schema test
\i test_schema.sql
```
This will validate:
- All tables exist and have correct structure
- RLS is enabled on all tables
- Indexes are properly created
- Foreign key constraints are in place
- Sample data integrity
- Helper functions are working

#### Step 3: Test Job Rankings
```sql
-- Run the job rankings demonstration
\i test_simple_rankings.sql
```
This will show:
- Job requirements for the Senior Full Stack Developer position
- Candidate rankings with AI match scores
- Detailed analysis of the top candidate
- Summary statistics

#### Step 4: View Results
The ranking test will display:
- **Job Requirements**: What the position requires
- **Candidate Rankings**: All candidates ranked by AI match score (0-100)
- **Top Candidate Analysis**: Detailed breakdown of the best match
- **Summary Statistics**: Overall performance metrics

### Expected Output:
```
Rank | Candidate Name    | Score | Rating    | AI Summary
-----|------------------|-------|-----------|------------------
1    | Alice Martinez   | 92.5  | 🌟 Excellent | Strong React and Node.js experience...
2    | Bob Thompson     | 78.0  | ✅ Good      | Good DevOps skills but limited frontend...
3    | Carol White      | 95.0  | 🌟 Excellent | Perfect match for DevOps role...
```

### Quick Test (5 minutes):
1. **Copy and paste** the migration files into Supabase SQL Editor
2. **Run** `test_schema.sql` to validate everything is working
3. **Run** `test_simple_rankings.sql` to see the ranking system in action
4. **Review** the results to understand how candidates are ranked by AI

### What the Tests Demonstrate:
- ✅ **Multi-tenant architecture** with proper data isolation
- ✅ **AI-powered candidate ranking** with detailed scoring
- ✅ **Comprehensive RLS policies** for security
- ✅ **Subscription management** for SaaS functionality
- ✅ **Real-world data relationships** and constraints

## 🔍 Query Examples

### Get Top Matches for a Job

```sql
SELECT 
    c.first_name || ' ' || c.last_name as candidate_name,
    c.email,
    mr.match_score,
    mr.ai_summary
FROM match_results mr
JOIN candidates c ON mr.candidate_id = c.id
WHERE mr.job_id = '11111111-1111-1111-1111-111111111111'
ORDER BY mr.match_score DESC
LIMIT 10;
```

### Get Organization Dashboard Data

```sql
SELECT 
    o.name as organization_name,
    COUNT(DISTINCT j.id) as total_jobs,
    COUNT(DISTINCT c.id) as total_candidates,
    COUNT(DISTINCT mr.id) as total_matches,
    ROUND(AVG(mr.match_score), 2) as avg_match_score
FROM organizations o
LEFT JOIN jobs j ON o.id = j.organization_id
LEFT JOIN candidates c ON o.id = c.organization_id
LEFT JOIN match_results mr ON o.id = mr.organization_id
WHERE o.id = get_user_organization_id()
GROUP BY o.id, o.name;

### Get Subscription Details for Organization

```sql
SELECT 
    o.name as organization_name,
    sp.name as plan_name,
    s.status as subscription_status,
    s.billing_cycle,
    s.current_period_end,
    sp.max_users,
    sp.max_jobs_per_month,
    sp.price_monthly,
    sp.price_yearly
FROM organizations o
JOIN subscriptions s ON o.current_subscription_id = s.id
JOIN subscription_plans sp ON s.plan_id = sp.id
WHERE o.id = '550e8400-e29b-41d4-a716-446655440001';
```

### Check Organization Usage vs Limits

```sql
SELECT 
    o.name as organization_name,
    sp.name as plan_name,
    su.users_count,
    sp.max_users as user_limit,
    su.jobs_created_count,
    sp.max_jobs_per_month as job_limit,
    su.candidates_added_count,
    sp.max_candidates as candidate_limit
FROM organizations o
JOIN subscriptions s ON o.current_subscription_id = s.id
JOIN subscription_plans sp ON s.plan_id = sp.id
LEFT JOIN subscription_usage su ON s.id = su.subscription_id 
    AND su.usage_date = CURRENT_DATE
WHERE o.id = '550e8400-e29b-41d4-a716-446655440001';
```
```

## 🛠️ Maintenance

### Adding New Organizations

```sql
-- First create the organization
INSERT INTO organizations (name, slug, domain, subscription_tier, max_users, max_jobs_per_month)
VALUES ('New Company', 'new-company', 'newcompany.com', 'basic', 10, 25);

-- Then create a subscription for the organization
INSERT INTO subscriptions (organization_id, plan_id, status, billing_cycle, current_period_start, current_period_end)
VALUES (
    'new-org-uuid',
    '550e8400-e29b-41d4-a716-446655440011', -- Basic plan
    'active',
    'monthly',
    CURRENT_DATE,
    CURRENT_DATE + INTERVAL '1 month'
);
```

### Adding New Users

```sql
-- First create user in Supabase Auth, then:
INSERT INTO user_profiles (id, organization_id, email, first_name, last_name, role)
VALUES ('new-user-uuid', 'org-uuid', 'user@company.com', 'John', 'Doe', 'recruiter');
```

## 🔧 Troubleshooting

### Common Issues

**Error: "insert or update on table 'user_profiles' violates foreign key constraint"**
- This occurs when trying to insert user profiles without corresponding auth.users entries
- Solution: Use `deploy_test.sql` for testing, or create auth users first

**Error: "function get_user_organization_id() does not exist"**
- This occurs when RLS policies are created before the helper functions
- Solution: Run migrations in the correct order (001_create_tables.sql first)

**Error: "permission denied for table auth.users"**
- This occurs when trying to create auth users without proper permissions
- Solution: Use Supabase Dashboard to create users, or run with service role

### Testing RLS Policies

To test RLS policies without auth users:

```sql
-- Temporarily disable RLS for testing
ALTER TABLE user_profiles DISABLE ROW LEVEL SECURITY;
-- Run your tests
-- Re-enable RLS
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
```

### Validation

Run the validation script to check your setup:

```sql
\i test_schema.sql
```

## 📝 Notes

- All timestamps use `TIMESTAMP WITH TIME ZONE` for proper timezone handling
- UUIDs are generated using `uuid_generate_v4()` function
- UUIDs follow the standard format: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` (hexadecimal characters only: 0-9, a-f)
- File paths reference Supabase Storage buckets
- AI processing status is tracked for resume analysis
- The schema is designed to be extensible for future features
- Use `deploy_test.sql` for quick testing without authentication setup
- Sample data uses predictable UUIDs for easy testing and reference

## 🤝 Contributing

When making changes:

1. Create new migration files with sequential numbering
2. Update seed files if new tables require sample data
3. Test RLS policies thoroughly
4. Update this README with any schema changes

## 📄 License

This database schema is part of a backend engineering test and is provided as-is for evaluation purposes.
