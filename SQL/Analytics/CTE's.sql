-- Q4: What is each therapist's utilization rate?
WITH TherapistStats AS (
    SELECT 
        t.therapist_id,
        t.name,
        t.specialization,
        COUNT(*) AS completed_sessions,
        SUM(a.duration_minutes) AS total_minutes
    FROM Therapists t
    JOIN Appointments a ON t.therapist_id = a.therapist_id
    WHERE a.status = 'completed'
    GROUP BY t.therapist_id, t.name, t.specialization
)
SELECT 
    therapist_id,
    name,
    specialization,
    completed_sessions,
    CAST(total_minutes / 60.0 AS DECIMAL(10,2)) AS booked_hours,
    CAST(total_minutes / 60.0 / completed_sessions AS DECIMAL(5,2)) AS avg_hours_per_session
FROM TherapistStats
ORDER BY booked_hours DESC;

-- Q5: Identify clients who haven't had an appointment in 90+ days (potential churn)
WITH LastAppointment AS (
    SELECT 
        c.client_id,
        c.age,
        c.gender,
        c.insurance_provider,
        t.name AS therapist_name,
        MAX(a.appointment_date) AS last_appointment_date,
        COUNT(a.appointment_id) AS total_sessions,
        DATEDIFF(DAY, MAX(a.appointment_date), GETDATE()) AS days_since_last_visit
    FROM Clients c
    JOIN Appointments a ON c.client_id = a.client_id
    JOIN Therapists t ON c.assigned_therapist_id = t.therapist_id
    WHERE a.status = 'completed'
    GROUP BY c.client_id, c.age, c.gender, c.insurance_provider, t.name
)
SELECT 
    CASE 
        WHEN days_since_last_visit >= 180 THEN 'Churned (180+ days)'
        WHEN days_since_last_visit >= 90 THEN 'At Risk (90-179 days)'
        ELSE 'Active (< 90 days)'
    END AS churn_status,
    COUNT(*) AS client_count,
    AVG(total_sessions) AS avg_sessions_before_churn,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM LastAppointment
GROUP BY 
    CASE 
        WHEN days_since_last_visit >= 180 THEN 'Churned (180+ days)'
        WHEN days_since_last_visit >= 90 THEN 'At Risk (90-179 days)'
        ELSE 'Active (< 90 days)'
    END
ORDER BY client_count DESC;

-- Q6: Which insurance provider generates the most revenue? What's the coverage breakdown?
WITH InsuranceMetrics AS (
    SELECT 
        c.insurance_provider,
        COUNT(DISTINCT c.client_id) AS total_clients,
        COUNT(b.billing_id) AS total_sessions_billed,
        SUM(b.amount_charged) AS total_revenue,
        SUM(b.insurance_coverage) AS total_insurance_paid,
        SUM(b.patient_responsibility) AS total_patient_paid
    FROM Clients c
    JOIN Appointments a ON c.client_id = a.client_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    GROUP BY c.insurance_provider
)
SELECT 
    insurance_provider,
    total_clients,
    total_sessions_billed,
    CAST(total_revenue AS DECIMAL(12,2)) AS total_revenue,
    CAST(total_insurance_paid AS DECIMAL(12,2)) AS insurance_coverage_amount,
    CAST(total_patient_paid AS DECIMAL(12,2)) AS patient_responsibility_amount,
    CAST((total_insurance_paid / total_revenue) * 100 AS DECIMAL(5,2)) AS insurance_coverage_percent,
    CAST(total_revenue / total_sessions_billed AS DECIMAL(10,2)) AS avg_revenue_per_session
FROM InsuranceMetrics
ORDER BY total_revenue DESC;