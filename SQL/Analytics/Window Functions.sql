-- Q7: Rank therapists by revenue with percentile analysis
SELECT 
    t.therapist_id,
    t.name,
    t.specialization,
    COUNT(b.billing_id) AS sessions_billed,
    CAST(SUM(b.amount_charged) AS DECIMAL(12,2)) AS total_revenue,
    RANK() OVER (ORDER BY SUM(b.amount_charged) DESC) AS revenue_rank,
    DENSE_RANK() OVER (ORDER BY SUM(b.amount_charged) DESC) AS revenue_dense_rank,
    CAST(PERCENT_RANK() OVER (ORDER BY SUM(b.amount_charged) DESC) * 100 AS DECIMAL(5,2)) AS percentile
FROM Therapists t
JOIN Appointments a ON t.therapist_id = a.therapist_id
JOIN Billing b ON a.appointment_id = b.appointment_id
GROUP BY t.therapist_id, t.name, t.specialization
ORDER BY total_revenue DESC;

-- Q8: Compare each therapist's monthly appointments to their personal average
WITH MonthlyAppointments AS (
    SELECT 
        t.therapist_id,
        t.name,
        YEAR(a.appointment_date) AS year,
        MONTH(a.appointment_date) AS month,
        COUNT(a.appointment_id) AS monthly_appointments
    FROM Therapists t
    JOIN Appointments a ON t.therapist_id = a.therapist_id
    WHERE a.status = 'completed'
    GROUP BY t.therapist_id, t.name, YEAR(a.appointment_date), MONTH(a.appointment_date)
)
SELECT 
    therapist_id,
    name,
    year,
    month,
    monthly_appointments,
    AVG(monthly_appointments) OVER (PARTITION BY therapist_id) AS personal_avg,
    monthly_appointments - AVG(monthly_appointments) OVER (PARTITION BY therapist_id) AS variance_from_avg,
    LAG(monthly_appointments) OVER (PARTITION BY therapist_id ORDER BY year, month) AS previous_month,
    monthly_appointments - LAG(monthly_appointments) OVER (PARTITION BY therapist_id ORDER BY year, month) AS month_over_month_change
FROM MonthlyAppointments
ORDER BY therapist_id, year, month;

-- Q9: Calculate cumulative revenue over time
WITH DailyRevenue AS (
    SELECT 
        CAST(a.appointment_date AS DATE) AS appointment_date,
        COUNT(b.billing_id) AS daily_sessions,
        SUM(b.amount_charged) AS daily_revenue
    FROM Appointments a
    JOIN Billing b ON a.appointment_id = b.appointment_id
    GROUP BY CAST(a.appointment_date AS DATE)
)
SELECT 
    appointment_date,
    daily_sessions,
    CAST(daily_revenue AS DECIMAL(12,2)) AS daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY appointment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_revenue,
    AVG(daily_revenue) OVER (ORDER BY appointment_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS seven_day_moving_avg
FROM DailyRevenue
ORDER BY appointment_date;