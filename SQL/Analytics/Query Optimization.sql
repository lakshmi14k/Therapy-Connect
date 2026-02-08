USE CounsellingManagement;
GO

-- Drop index if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'idx_appointments_status_covering')
    DROP INDEX idx_appointments_status_covering ON Appointments;
GO

-- ========== BEFORE OPTIMIZATION ==========
PRINT '========== BEFORE OPTIMIZATION ==========';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END AS retention_category,
    COUNT(*) AS client_count
FROM (
    SELECT client_id, COUNT(*) AS session_count
    FROM Appointments
    WHERE status = 'completed'
    GROUP BY client_id
) AS ClientSessions
GROUP BY 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- Create index
CREATE NONCLUSTERED INDEX idx_appointments_status_covering 
ON Appointments(status) INCLUDE (client_id);
GO

-- ========== AFTER OPTIMIZATION ==========
PRINT '========== AFTER OPTIMIZATION ==========';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END AS retention_category,
    COUNT(*) AS client_count
FROM (
    SELECT client_id, COUNT(*) AS session_count
    FROM Appointments
    WHERE status = 'completed'
    GROUP BY client_id
) AS ClientSessions
GROUP BY 
    CASE 
        WHEN session_count = 1 THEN '1 session (churned)'
        WHEN session_count BETWEEN 2 AND 4 THEN '2-4 sessions'
        WHEN session_count BETWEEN 5 AND 9 THEN '5-9 sessions'
        WHEN session_count >= 10 THEN '10+ sessions (retained)'
    END;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO