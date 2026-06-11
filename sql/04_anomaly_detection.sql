-- =====================================================
-- Query 4: Revenue Anomaly Detection
-- Uses z-score statistical method to flag months
-- with unusual revenue patterns
-- =====================================================

WITH monthly_stats AS (
    SELECT
        DATE_FORMAT(OrderDate, 'yyyy-MM')       AS order_month,
        COUNT(DISTINCT SalesOrderID)             AS num_orders,
        ROUND(SUM(TotalDue), 2)                  AS monthly_revenue,
        ROUND(AVG(TotalDue), 2)                  AS avg_order_value
    FROM salesorderheader
    GROUP BY DATE_FORMAT(OrderDate, 'yyyy-MM')
),
stats_with_zscore AS (
    SELECT
        order_month,
        num_orders,
        monthly_revenue,
        avg_order_value,
        ROUND(AVG(monthly_revenue) OVER (), 2)    AS mean_revenue,
        ROUND(STDDEV(monthly_revenue) OVER (), 2) AS stddev_revenue,
        ROUND(
            (monthly_revenue - AVG(monthly_revenue) OVER ())
            / NULLIF(STDDEV(monthly_revenue) OVER (), 0),
        2)                                         AS z_score
    FROM monthly_stats
)
SELECT
    order_month,
    num_orders,
    monthly_revenue,
    avg_order_value,
    mean_revenue,
    stddev_revenue,
    z_score,
    CASE
        WHEN ABS(z_score) > 2 THEN 'Anomaly'
        WHEN ABS(z_score) > 1 THEN 'Watch'
        ELSE 'Normal'
    END AS flag
FROM stats_with_zscore
ORDER BY order_month;