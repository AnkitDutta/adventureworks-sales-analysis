-- =====================================================
-- Query 5: Territory Performance Analysis
-- Breaks down revenue, orders, and customer count
-- by territory with regional rankings
-- =====================================================

WITH territory_orders AS (
    SELECT
        st.Name                                   AS territory,
        st.Group                                  AS region,
        COUNT(DISTINCT soh.SalesOrderID)          AS num_orders,
        COUNT(DISTINCT soh.CustomerID)            AS unique_customers,
        ROUND(SUM(soh.TotalDue), 2)               AS total_revenue,
        ROUND(AVG(soh.TotalDue), 2)               AS avg_order_value,
        ROUND(SUM(sp.SalesYTD), 2)                AS rep_sales_ytd
    FROM salesterritory st
    LEFT JOIN salesorderheader soh  ON st.TerritoryID = soh.TerritoryID
    LEFT JOIN salesperson sp        ON st.TerritoryID = sp.TerritoryID
    GROUP BY st.Name, st.Group
),
ranked AS (
    SELECT
        *,
        ROUND(total_revenue / SUM(total_revenue) OVER () * 100, 2) AS revenue_share_pct,
        RANK() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS rank_in_region
    FROM territory_orders
)
SELECT
    territory,
    region,
    num_orders,
    unique_customers,
    total_revenue,
    avg_order_value,
    revenue_share_pct,
    rank_in_region
FROM ranked
ORDER BY total_revenue DESC;