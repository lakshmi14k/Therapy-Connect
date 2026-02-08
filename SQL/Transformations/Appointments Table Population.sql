-- Populate Appointments table 
INSERT INTO Appointments (
    appointment_id,
    client_id,
    therapist_id,
    appointment_date,
    duration_minutes,
    session_type,
    status,
    cancellation_reason
)
SELECT 
    v.AppointmentID AS appointment_id,
    v.PatientId AS client_id,
    c.assigned_therapist_id AS therapist_id,
    v.AppointmentDay AS appointment_date,
    45 + (ABS(CAST(v.AppointmentID AS INT) % 16)) AS duration_minutes,  -- Random 45-60 mins
    CASE 
        WHEN ABS(CAST(v.AppointmentID AS INT) % 10) < 7 THEN 'in-person'
        ELSE 'virtual'
    END AS session_type,
    CASE 
        WHEN v.No_show = 'Yes' THEN 'no-show'
        ELSE 'completed'
    END AS status,
    CASE 
        WHEN v.No_show = 'Yes' AND v.SMS_received = 0 THEN 'No reminder sent'
        WHEN v.No_show = 'Yes' THEN 'Patient unavailable'
        ELSE NULL
    END AS cancellation_reason
FROM vw_CleanAppointments v
JOIN Clients c ON v.PatientId = c.client_id;
GO