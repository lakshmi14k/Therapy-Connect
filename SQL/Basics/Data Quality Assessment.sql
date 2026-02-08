-- Check 1: NULL PatientIds
SELECT COUNT(*) AS null_patient_ids
FROM StagingAppointments
WHERE PatientId IS NULL;

-- Check 2: NULL AppointmentIDs
SELECT COUNT(*) AS null_appointment_ids
FROM StagingAppointments
WHERE AppointmentID IS NULL;

-- Check 3: Invalid ages (negative or impossible)
SELECT COUNT(*) AS invalid_ages
FROM StagingAppointments
WHERE Age < 0 OR Age > 120;

-- Check 4: Future appointment dates (impossible)
SELECT COUNT(*) AS future_appointments
FROM StagingAppointments
WHERE AppointmentDay > GETDATE();

-- Check 5: Scheduled after appointment (logic error)
SELECT COUNT(*) AS scheduling_errors
FROM StagingAppointments
WHERE ScheduledDay > AppointmentDay;