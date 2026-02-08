**Remote Counselling Management System**

**Problem Statement:** Mental health clinics struggle with poor client retention (66% churn after first session), therapist workload imbalances, and lack of data-driven insights for operational improvements.

**Proposed Solution:** A normalized SQL database with advanced analytics to track retention metrics, therapist utilization, treatment outcomes, and revenue patterns, enabling data-driven decisions for clinic operations.

**Key Findings:**
- **66% immediate churn** - 35,705 clients attended only 1 session (major retention crisis)
- **$2.45M revenue opportunity** - 10% unpaid bills, average session cost $160
- **20% no-show rate** across all therapists (22,319 missed appointments)
- **82% query performance improvement** through index optimization
- **100% treatment completion** for clients with 10+ sessions

**Dataset Overview:**

Real-world medical appointment dataset with intentional data quality challenges.
- **Total Records:** 110,527 appointments
- **Time Period:** 3 months (April-June 2016)
- **Patients:** 62,294 unique clients
- **Therapists:** 15 across 5 specializations
- **Data Issues:** NULL IDs (5), demographic inconsistencies (1,168), scheduling errors (38,568)

**Tech Stack:**
- **Database:** Microsoft SQL Server (SSMS)
- **Language:** T-SQL
- **Techniques:** CTEs, Window Functions, Query Optimization, Index Design
- **Data:** 110K+ rows across 6 normalized tables
- **Visualization:** Tableau

**Project Structure:**
```
TherapyConnect/
├── Data/
│   └── Raw Dataset.csv                       Source data (110K appointments)
│
├── sql/
│   ├── Basics/                               Foundation setup
│   │   ├── Basic Data Load.sql               Staging table creation
│   │   ├── Create Tables.sql                 6-table normalized schema
│   │   ├── Data Quality Assessment.sql       Identify issues
│   │   ├── Clean Appointments - View.sql     Clean data view
│   │   └── Generate Therapists.sql           Dimension data generation
│   │
│   ├── Transformations/                      ETL logic in SQL
│   │   ├── Client Table Population.sql       62K unique patients
│   │   ├── Appointments Table Population.sql  110K appointments
│   │   ├── Treatment Plan Table Population.sql  14K plans
│   │   ├── Session Notes Table Population.sql  88K notes
│   │   ├── Billing Table Population.sql      88K transactions
│   │   └── Final Validations.sql             Data integrity checks
│   │
│   └── Analytics/                            Business intelligence queries
│       ├── Basic Analytics.sql               Therapist workload, revenue trends
│       ├── CTE's.sql                         Utilization rates, churn analysis
│       ├── Window Functions.sql              Rankings, running totals, LAG/LEAD
│       ├── Complex Business Logic.sql        Multi-table analysis
│       └── Query Optimization.sql            Performance improvement (82% faster)
│
├── Diagrams/
│   └── Optimization - Execution Plan.sqlplan  Before/after query plans
│
└── README.md
```

**Database Schema**

**6 Normalized Tables:**
```
Therapists (15)
    ↓
Clients (62,294) ← assigned_therapist_id
    ↓
Appointments (110,522) ← client_id, therapist_id
    ↓
├── SessionNotes (88,203) ← appointment_id
├── Billing (88,203) ← appointment_id
└── TreatmentPlans (14,434) ← client_id, therapist_id
```

**Key Metrics Calculated:**
- Client retention cohorts (1 session vs 10+ sessions)
- Therapist utilization (booked hours, no-show rates)
- Revenue analysis (insurance coverage, payment status)
- Treatment outcomes (progress ratings, completion rates)

**Installation Steps:**

**Prerequisites:** SQL Server + SSMS

1. **Create database:**
```sql
   CREATE DATABASE CounsellingManagement;
```

2. **Load raw data:**
   - Run `sql/Basics/Basic Data Load.sql`
   - Import `Data/Raw Dataset.csv` via SSMS Import Wizard

3. **Build schema:**
```sql
   -- Execute in order:
   sql/Basics/Create Tables.sql
   sql/Basics/Data Quality Assessment.sql
   sql/Basics/Clean Appointments - View.sql
   sql/Basics/Generate Therapists.sql
```

4. **Transform data:**
```sql
   -- Execute all files in sql/Transformations/ folder
```

5. **Run analytics:**
```sql
   -- Execute queries in sql/Analytics/ as needed
```

**Results:**

**Database Built:**
- 6 normalized tables
- 1 data quality view
- 110,522 transformed records
- 12 advanced analytical queries

**Performance Optimization:**
- **Before:** 172ms CPU time, 198ms elapsed
- **After:** 31ms CPU time, 49ms elapsed
- **Improvement:** 82% faster (5.5x speed increase)

**Business Insights:**
- 66% churn after first session (retention crisis)
- Depression cases show best outcomes (7/10 progress rating)
- Private Insurance clients generate more revenue ($12.9M vs $1.3M)
- Therapist workload ranges 2,872-5,837 hours (rebalancing needed)

**SQL Capabilities Demonstrated:**
- **Advanced SQL:** CTEs, Window Functions (RANK, NTILE, LAG/LEAD), Subqueries  
- **ETL Design:** Staging → Transformation → Analytics pipeline  
- **Data Quality:** NULL handling, deduplication, inconsistency resolution  
- **Performance:** Query optimization, covering indexes, execution plans  
- **Business Logic:** Retention cohorts, utilization metrics, revenue analysis  
- **Database Design:** Normalization, foreign keys, indexing strategy  

Built with _T-SQL, SQL Server, and Data-Driven Problem Solving_

**For detailed project documentation, click [here](Docs/Project_Documentation.docx)**
