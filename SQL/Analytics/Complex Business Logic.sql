-- Q10: Find therapists whose no-show rate is above the clinic average
WITH TherapistNoShows AS (
    SELECT 
        t.therapist_id,
        t.name,
        t.specialization,
        COUNT(a.appointment_id) AS total_appointments,
        COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) AS no_shows,
        CAST(COUNT(CASE WHEN a.status = 'no-show' THEN 1 END) * 100.0 / COUNT(a.appointment_id) AS DECIMAL(5,2)) AS no_show_rate
    FROM Therapists t
    JOIN Appointments a ON t.therapist_id = a.therapist_id
    GROUP BY t.therapist_id, t.name, t.specialization
)
SELECT 
    therapist_id,
    name,
    specialization,
    total_appointments,
    no_shows,
    no_show_rate,
    (SELECT AVG(no_show_rate) FROM TherapistNoShows) AS clinic_avg_no_show_rate,
    no_show_rate - (SELECT AVG(no_show_rate) FROM TherapistNoShows) AS variance_from_avg
FROM TherapistNoShows
WHERE no_show_rate > (SELECT AVG(no_show_rate) FROM TherapistNoShows)
ORDER BY no_show_rate DESC;

-- Q11: Identify top 20% of clients by total spending (high-value clients)
WITH ClientSpending AS (
    SELECT 
        c.client_id,
        c.age,
        c.gender,
        c.insurance_provider,
        t.name AS therapist_name,
        COUNT(a.appointment_id) AS total_sessions,
        SUM(b.amount_charged) AS total_spent,
        AVG(sn.progress_rating) AS avg_progress_rating
    FROM Clients c
    JOIN Appointments a ON c.client_id = a.client_id
    JOIN Billing b ON a.appointment_id = b.appointment_id
    JOIN Therapists t ON c.assigned_therapist_id = t.therapist_id
    LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
    WHERE a.status = 'completed'
    GROUP BY c.client_id, c.age, c.gender, c.insurance_provider, t.name
),
RankedClients AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_quintile
    FROM ClientSpending
)
SELECT 
    client_id,
    age,
    gender,
    insurance_provider,
    therapist_name,
    total_sessions,
    CAST(total_spent AS DECIMAL(10,2)) AS total_spent,
    CAST(avg_progress_rating AS DECIMAL(3,2)) AS avg_progress_rating,
    spending_quintile
FROM RankedClients
WHERE spending_quintile = 1  -- Top 20%
ORDER BY total_spent DESC;

-- Q12: Which diagnosis has the best treatment outcomes?
SELECT 
    tp.diagnosis,
    COUNT(DISTINCT tp.client_id) AS clients_treated,
    COUNT(DISTINCT CASE WHEN tp.plan_status = 'Completed' THEN tp.client_id END) AS completed_plans,
    CAST(COUNT(DISTINCT CASE WHEN tp.plan_status = 'Completed' THEN tp.client_id END) * 100.0 / 
         COUNT(DISTINCT tp.client_id) AS DECIMAL(5,2)) AS completion_rate,
    AVG(sn.progress_rating) AS avg_progress_rating,
    AVG(DATEDIFF(DAY, tp.start_date, COALESCE(tp.end_date, GETDATE()))) AS avg_treatment_days,
    COUNT(a.appointment_id) AS total_sessions
FROM TreatmentPlans tp
JOIN Appointments a ON tp.client_id = a.client_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
WHERE a.status = 'completed'
GROUP BY tp.diagnosis
ORDER BY avg_progress_rating DESC, completion_rate DESC;