-- Populate Treatment Plans
INSERT INTO TreatmentPlans (
    client_id,
    therapist_id,
    diagnosis,
    treatment_goals,
    start_date,
    end_date,
    plan_status
)
SELECT DISTINCT
    v.PatientId AS client_id,
    c.assigned_therapist_id AS therapist_id,
    CASE 
        WHEN v.Hipertension = 1 AND v.Diabetes = 1 THEN 'Comorbid Anxiety & Depression'
        WHEN v.Hipertension = 1 THEN 'Generalized Anxiety Disorder'
        WHEN v.Diabetes = 1 THEN 'Depression (Chronic Illness)'
        WHEN v.Alcoholism = 1 THEN 'Substance Use Disorder'
        WHEN v.Handcap > 0 THEN 'Adjustment Disorder'
        ELSE 'General Mental Health Support'
    END AS diagnosis,
    'Improve coping strategies and symptom management' AS treatment_goals,
    CAST(MIN(v.ScheduledDay) AS DATE) AS start_date,
    CASE 
        WHEN MAX(v.AppointmentDay) < DATEADD(DAY, -90, GETDATE()) 
        THEN CAST(DATEADD(DAY, 90, MAX(v.AppointmentDay)) AS DATE)
        ELSE NULL  -- Ongoing treatment
    END AS end_date,
	CASE 
        WHEN MAX(v.AppointmentDay) < DATEADD(DAY, -90, GETDATE()) 
        THEN 'Completed'
        ELSE 'Active'
    END AS plan_status
FROM vw_CleanAppointments v
JOIN Clients c ON v.PatientId = c.client_id
WHERE v.Hipertension = 1 
   OR v.Diabetes = 1 
   OR v.Alcoholism = 1 
   OR v.Handcap > 0
GROUP BY 
    v.PatientId, 
    c.assigned_therapist_id, 
    v.Hipertension, 
    v.Diabetes, 
    v.Alcoholism, 
    v.Handcap;
GO