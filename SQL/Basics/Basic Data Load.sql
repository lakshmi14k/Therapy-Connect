--Create Database
CREATE DATABASE CounsellingManagement;
GO

--Use Database
USE CounsellingManagement;
GO

--Create Staging Table
CREATE TABLE staging_appointments (
    patient_id BIGINT,
    appointment_id BIGINT PRIMARY KEY,
    gender VARCHAR(10),
    scheduled_day DATETIME,
    appointment_day DATETIME,
    age INT,
    neighbourhood VARCHAR(100),
    scholarship INT,
    hipertension INT,
    diabetes INT,
    alcoholism INT,
    handcap INT,
    sms_received INT,
    no_show VARCHAR(10)
);
GO

--Imported as Flatfile

--Data Validation
USE CounsellingManagement;
GO

-- Check total rows
SELECT COUNT(*) AS total_rows 
FROM StagingAppointments;

-- Preview first 10 rows
SELECT TOP 10 * 
FROM dbo.StagingAppointments;

-- Check for any completely empty rows
SELECT COUNT(*) AS rows_with_data
FROM StagingAppointments
WHERE AppointmentId IS NOT NULL;