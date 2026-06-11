-- =====================================================
-- Query 1: Sales Rep Performance Rankings
-- Ranks all sales reps by YTD revenue and calculates
-- quota attainment percentage
-- =====================================================

SELECT
    p.FirstName || ' ' || p.LastName     AS rep_name,
    st.Name                               AS territory,
    ROUND(sp.SalesYTD, 2)                AS sales_ytd,
    ROUND(sp.SalesLastYear, 2)           AS sales_last_year,
    ROUND(sp.SalesQuota, 2)              AS quota,
    ROUND(sp.SalesYTD / NULLIF(sp.SalesQuota, 0) * 100, 1)  AS attainment_pct,
    RANK() OVER (ORDER BY sp.SalesYTD DESC)                  AS sales_rank
FROM salesperson sp
LEFT JOIN employee e        ON sp.BusinessEntityID = e.BusinessEntityID
LEFT JOIN person p          ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN salesterritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY sales_rank