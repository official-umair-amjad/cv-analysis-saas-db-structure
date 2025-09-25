# Multi-Tenant SaaS Recruitment Platform - Database Schema

This repository contains the database schema for a multi-tenant SaaS recruitment platform built with Supabase/PostgreSQL. The system allows recruitment companies to upload job descriptions and candidate CVs, then uses AI to match candidates to jobs with scoring and recommendations.

## Loom Video link, Explaining

- link explaining Schema and RLS: https://www.loom.com/share/a657f762746f46f39496e7ae21b9853b?sid=0fb4cd23-ece9-4337-a949-0783762374ef
- link showing and testing in SUpabase: https://www.loom.com/share/54f33a12dac842e18b0e935d8ba50e54?sid=12a474af-e6d6-4fb6-9cc5-f3181ede9a92

## The English Test results

[![English Test Results](./english test ss.png)](./english test ss.pdf)

## Architecture Overview

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
│   ├── 001_create_auth_users.sql  # Auth users creation
│   ├── 002_seed_organizations.sql  # Sample organizations
│   ├── 003_seed_users.sql         # Sample user profiles
│   ├── 004_seed_jobs_candidates.sql # Sample jobs, candidates, and matches
│   └── 005_seed_subscription_plans.sql # Sample subscription plans and data
└── README.md                      # This file
```

## 🚀 Deployment Instructions

### Prerequisites

- Supabase project set up
- Database access with appropriate permissions


### Option 2: Full Production Deployment

For production use with proper authentication:

#### Step 1: Run Migrations from folders mentioned by copying the files in order and running it in supabase table

```sql
-- Run in Supabase SQL Editor or via CLI
\i migrations/001_create_tables.sql
\i migrations/002_create_subscription_table.sql
\i migrations/003_create_rls_policies.sql
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
\i seed/001_create_auth_users.sql
```

#### Step 3: Seed Sample Data

```sql
-- Run seed files in order
\i seed/002_seed_organizations.sql
\i seed/003_seed_users.sql
\i seed/004_seed_jobs_candidates.sql
\i seed/005_seed_subscription_plans.sql

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

### Expected Output:
```
Rank | Candidate Name    | Score | Rating    | AI Summary
-----|------------------|-------|-----------|------------------
1    | Alice Martinez   | 92.5  | 🌟 Excellent | Strong React and Node.js experience...
2    | Bob Thompson     | 78.0  | ✅ Good      | Good DevOps skills but limited frontend...
3    | Carol White      | 95.0  | 🌟 Excellent | Perfect match for DevOps role...
4    | More...          | 0.0.. | 🌟 Excellent | Perfect match for role...
```
## 🔒 Security Model

### Row Level Security (RLS)

The system implements comprehensive RLS policies to ensure complete data isolation between organizations:

- **Organization Isolation**: Users can only access data from their own organization
- **Role-Based Access**: Different permissions for admins, recruiters, and viewers
- **Helper Functions**: Secure functions to get user organization and role information
- **Audit Functions**: Organization statistics and reporting functions


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


### Key Security Features

1. **Multi-tenant Isolation**: Complete data separation between organizations
2. **Role-based Permissions**: Granular access control based on user roles
3. **Secure Functions**: Helper functions with SECURITY DEFINER for safe access
4. **Audit Logging**: Built-in tracking of data changes and access


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
