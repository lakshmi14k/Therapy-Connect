CREATE VIEW vw_CleanAppointments AS
SELECT 
    PatientId,
    AppointmentID,
    Gender,
    ScheduledDay,
    AppointmentDay,
    Age,
    Neighbourhood,
    Scholarship,
    Hipertension,
    Diabetes,
    Alcoholism,
    Handcap,
    SMS_received,
    No_show,
    -- Add data quality flag
    CASE 
        WHEN ScheduledDay > AppointmentDay THEN 1 
        ELSE 0 
    END AS scheduling_error_flag
FROM StagingAppointments
WHERE PatientId IS NOT NULL  -- Exclude NULL patient IDs
;
GO

--Validations
--Check the clean data
SELECT COUNT(*) AS clean_row_count
FROM vw_CleanAppointments;

-- Verify no NULL patient IDs
SELECT COUNT(*) AS should_be_zero
FROM vw_CleanAppointments
WHERE PatientId IS NULL;