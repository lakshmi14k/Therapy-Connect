USE CounsellingManagement;
GO

-- Generate therapists - Recursive CTE
WITH TherapistNumbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 
    FROM TherapistNumbers 
    WHERE n < 15
)
INSERT INTO Therapists (name, specialization, years_experience, hourly_rate)
SELECT 
    'Dr. ' + CASE n
        WHEN 1 THEN 'Sarah Martinez'
        WHEN 2 THEN 'James Chen'
        WHEN 3 THEN 'Emily Rodriguez'
        WHEN 4 THEN 'Michael Thompson'
        WHEN 5 THEN 'Jessica Lee'
        WHEN 6 THEN 'David Kim'
        WHEN 7 THEN 'Amanda Silva'
        WHEN 8 THEN 'Robert Johnson'
        WHEN 9 THEN 'Maria Garcia'
        WHEN 10 THEN 'Christopher Brown'
        WHEN 11 THEN 'Jennifer Davis'
        WHEN 12 THEN 'Daniel Wilson'
        WHEN 13 THEN 'Lisa Anderson'
        WHEN 14 THEN 'Kevin White'
        ELSE 'Patricia Taylor'
    END AS name,
    CASE (n % 5)
        WHEN 0 THEN 'Anxiety Disorders'
        WHEN 1 THEN 'Depression & Mood'
        WHEN 2 THEN 'Substance Abuse'
        WHEN 3 THEN 'Chronic Illness Support'
        ELSE 'Family Therapy'
    END AS specialization,
    5 + (n % 15) AS years_experience,
    120 + (n * 5) AS hourly_rate
FROM TherapistNumbers
OPTION (MAXRECURSION 15);
GO

--Validation
SELECT * FROM Therapists;
GO