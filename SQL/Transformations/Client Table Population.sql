--Populate Client Table
-- Use a CTE to get the most recent demographics for each patient
WITH RankedPatients AS (
    SELECT 
        PatientId,
        Age,
        Gender,
        Neighbourhood,
        Scholarship,
        ScheduledDay,
        -- Rank by most recent scheduled date
        ROW_NUMBER() OVER (
            PARTITION BY PatientId 
            ORDER BY ScheduledDay DESC
        ) AS rn
    FROM vw_CleanAppointments
)
INSERT INTO Clients (
    client_id, 
    age, 
    gender, 
    neighbourhood, 
    insurance_provider,
    registration_date,
    assigned_therapist_id
)
SELECT 
    rp.PatientId AS client_id,
    rp.Age,
    rp.Gender,
    rp.Neighbourhood,
    CASE 
        WHEN rp.Scholarship = 1 THEN 'Medicare'
        ELSE 'Private Insurance'
    END AS insurance_provider,
    CAST(MIN(v.ScheduledDay) AS DATE) AS registration_date,
    ((CAST(rp.PatientId AS BIGINT) % 15) + 1) AS assigned_therapist_id
FROM RankedPatients rp
JOIN vw_CleanAppointments v ON rp.PatientId = v.PatientId
WHERE rp.rn = 1  -- Only take most recent demographics
GROUP BY rp.PatientId, rp.Age, rp.Gender, rp.Neighbourhood, rp.Scholarship;
GO

--Validation
-- Verify clients
SELECT COUNT(*) AS total_clients FROM Clients;

-- Check therapist distribution
SELECT 
    assigned_therapist_id,
    COUNT(*) AS client_count
FROM Clients
GROUP BY assigned_therapist_id
ORDER BY assigned_therapist_id;