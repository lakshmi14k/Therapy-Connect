-- Populate Session Notes
INSERT INTO SessionNotes (
    appointment_id,
    session_summary,
    progress_rating,
    next_steps
)
SELECT 
    appointment_id,
    'Client engaged in session. Discussed coping strategies and progress toward treatment goals.' AS session_summary,
    5 + (ABS(CAST(appointment_id AS INT) % 5)) AS progress_rating,  -- Random 5-9
    'Continue weekly sessions. Practice mindfulness and stress management techniques.' AS next_steps
FROM Appointments
WHERE status = 'completed';
GO