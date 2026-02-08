-- Populate Billing Table
INSERT INTO Billing (
    appointment_id,
    amount_charged,
    insurance_coverage,
    patient_responsibility,
    payment_status,
    payment_date
)
SELECT 
    a.appointment_id,
    t.hourly_rate AS amount_charged,
    CASE 
        WHEN c.insurance_provider = 'Medicare' THEN t.hourly_rate * 0.80
        ELSE t.hourly_rate * 0.70
    END AS insurance_coverage,
    CASE 
        WHEN c.insurance_provider = 'Medicare' THEN t.hourly_rate * 0.20
        ELSE t.hourly_rate * 0.30
    END AS patient_responsibility,
    CASE 
        WHEN ABS(CAST(a.appointment_id AS INT) % 10) < 9 THEN 'paid'
        ELSE 'pending'
    END AS payment_status,
    CASE 
        WHEN ABS(CAST(a.appointment_id AS INT) % 10) < 9 
        THEN CAST(DATEADD(DAY, 7, a.appointment_date) AS DATE)
        ELSE NULL
    END AS payment_date
FROM Appointments a
JOIN Clients c ON a.client_id = c.client_id
JOIN Therapists t ON a.therapist_id = t.therapist_id
WHERE a.status = 'completed';
GO