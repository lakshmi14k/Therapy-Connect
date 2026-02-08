-- Summary of all tables (Transformations)
SELECT 'Therapists' AS table_name, COUNT(*) AS row_count FROM Therapists
UNION ALL
SELECT 'Clients', COUNT(*) FROM Clients
UNION ALL
SELECT 'Appointments', COUNT(*) FROM Appointments
UNION ALL
SELECT 'TreatmentPlans', COUNT(*) FROM TreatmentPlans
UNION ALL
SELECT 'SessionNotes', COUNT(*) FROM SessionNotes
UNION ALL
SELECT 'Billing', COUNT(*) FROM Billing;