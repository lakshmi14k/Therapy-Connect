-- Q1: How many appointments has each therapist handled?
SELECT 
    t.therapist_id,
    t.name,
    t.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    COUNT(CASE WHEN a.status = 'completed' THEN 1 END) AS completed_appointments,
    COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) AS no_shows,
    CAST(COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) * 100.0 / COUNT(a.appointment_id) AS DECIMAL(5,2)) AS no_show_rate
FROM Therapists t
JOIN Appointments a ON t.therapist_id = a.therapist_id
GROUP BY t.therapist_id, t.name, t.specialization
ORDER BY total_appointments DESC;

-- Q2: What is the monthly revenue trend over time?
SELECT 
    YEAR(a.appointment_date) AS year,
    MONTH(a.appointment_date) AS month,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(b.amount_charged) AS total_revenue,
    SUM(b.insurance_coverage) AS insurance_paid,
    SUM(b.patient_responsibility) AS patient_paid,
    AVG(b.amount_charged) AS avg_session_cost
FROM Appointments a
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE a.status = 'completed'
GROUP BY YEAR(a.appointment_date), MONTH(a.appointment_date)
ORDER BY year, month;

-- Q3: How many sessions has each client attended? (Retention metric)
SELECT 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END AS retention_category,
    COUNT(*) AS client_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM (
    SELECT 
        client_id,
        COUNT(*) AS session_count
    FROM Appointments
    WHERE status = 'completed'
    GROUP BY client_id
) AS ClientSessions
GROUP BY 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END
ORDER BY client_count DESC;

