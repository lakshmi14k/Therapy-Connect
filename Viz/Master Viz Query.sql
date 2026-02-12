SELECT 
    -- Appointment Info
    a.appointment_id,
    a.appointment_date,
    YEAR(a.appointment_date) AS year,
    MONTH(a.appointment_date) AS month,
    DATENAME(MONTH, a.appointment_date) AS month_name,
    a.status,
    a.duration_minutes,
    
    -- Therapist Info
    t.therapist_id,
    t.name AS therapist_name,
    t.specialization,
    
    -- Client Info
    c.client_id,
    c.age,
    c.gender,
    c.insurance_provider,
    
    -- Billing Info
    b.amount_charged,
    b.insurance_coverage,
    b.patient_responsibility,
    b.payment_status,
    
    -- Treatment Info
    tp.diagnosis,
    tp.plan_status,
    sn.progress_rating

FROM Appointments a
JOIN Therapists t ON a.therapist_id = t.therapist_id
JOIN Clients c ON a.client_id = c.client_id
LEFT JOIN Billing b ON a.appointment_id = b.appointment_id
LEFT JOIN SessionNotes sn ON a.appointment_id = sn.appointment_id
LEFT JOIN TreatmentPlans tp ON c.client_id = tp.client_id

ORDER BY a.appointment_date;