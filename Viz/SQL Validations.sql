--Viz Validations
--1)Total Revenue
SELECT SUM(amount_charged) AS total_revenue
FROM Billing;

--2)Total Clients
SELECT COUNT(DISTINCT a.client_id) AS total_clients_with_appointments
FROM Appointments a;

--3) Average Sessions per Client
SELECT 
    CAST(COUNT(a.appointment_id) * 1.0 / COUNT(DISTINCT c.client_id) AS DECIMAL(5,2)) AS avg_sessions_per_client
FROM Appointments a
JOIN Therapists t ON a.therapist_id = t.therapist_id
JOIN Clients c ON a.client_id = c.client_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id;

--4) No Show Rate
SELECT 
    CAST(COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) * 100.0 / COUNT(a.appointment_id) AS DECIMAL(5,2)) AS no_show_rate_percent
FROM Appointments a
JOIN Therapists t ON a.therapist_id = t.therapist_id
JOIN Clients c ON a.client_id = c.client_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id;

--5)Retention Breakdown
SELECT 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END AS retention_category,
    COUNT(*) AS client_count
FROM (
    SELECT 
        c.client_id,
        COUNT(a.appointment_id) AS session_count
    FROM Appointments a
    JOIN Therapists t ON a.therapist_id = t.therapist_id
    JOIN Clients c ON a.client_id = c.client_id
    LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
    LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
    LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id
    GROUP BY c.client_id
) AS ClientSessions
GROUP BY 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END
ORDER BY client_count DESC;

--6) Monthly Revenue Trends
SELECT 
    YEAR(a.appointment_date) AS year,
    MONTH(a.appointment_date) AS month,
    CAST(SUM(b.amount_charged) AS DECIMAL(12,2)) AS total_revenue
FROM Appointments a
JOIN Therapists t ON a.therapist_id = t.therapist_id
JOIN Clients c ON a.client_id = c.client_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id
WHERE a.status = 'completed'
GROUP BY YEAR(a.appointment_date), MONTH(a.appointment_date)
ORDER BY year, month;

--7) Therapist Performance
SELECT 
    t.name,
    t.specialization,
    COUNT(a.appointment_id) AS total_sessions,
    CAST(COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) * 100.0 / COUNT(a.appointment_id) AS DECIMAL(5,2)) AS no_show_rate
FROM Appointments a
JOIN Therapists t ON a.therapist_id = t.therapist_id
JOIN Clients c ON a.client_id = c.client_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id
GROUP BY t.name, t.specialization
ORDER BY total_sessions DESC;
