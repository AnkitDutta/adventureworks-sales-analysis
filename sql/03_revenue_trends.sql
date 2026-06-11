-- =====================================================
-- Query 3: Monthly Revenue Trends
-- Tracks monthly revenue with MoM change and
-- running total using window functions
-- =====================================================

SELECT
    DATE_FORMAT(OrderDate, 'yyyy-MM')            AS order_month,
    COUNT(DISTINCT SalesOrderID)                  AS num_orders,
    ROUND(SUM(TotalDue), 2)                       AS monthly_revenue,
    ROUND(SUM(TotalDue) - LAG(SUM(TotalDue))
        OVER (ORDER BY DATE_FORMAT(OrderDate, 'yyyy-MM')), 2)   AS mom_change,
    ROUND(SUM(SUM(TotalDue))
        OVER (ORDER BY DATE_FORMAT(OrderDate, 'yyyy-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2)   AS running_total
FROM salesorderheader
GROUP BY DATE_FORMAT(OrderDate, 'yyyy-MM')
ORDER BY order_month;