-- =====================================================
-- Query 2: Quota Attainment Tiering
-- Buckets sales reps into performance tiers based on
-- attainment percentage against assigned quota
-- =====================================================

SELECT
    p.FirstName || ' ' || p.LastName   AS rep_name,
    ROUND(sp.SalesYTD, 2)              AS sales_ytd,
    ROUND(sp.SalesQuota, 2)            AS quota,
    ROUND(sp.SalesYTD / NULLIF(sp.SalesQuota, 0) * 100, 1) AS attainment_pct,
    CASE
        WHEN sp.SalesQuota IS NULL THEN 'No Quota Assigned'
        WHEN sp.SalesYTD / NULLIF(sp.SalesQuota, 0) >= 1.5 THEN 'Overachiever (150%+)'
        WHEN sp.SalesYTD / NULLIF(sp.SalesQuota, 0) >= 1.0 THEN 'On Target (100-149%)'
        WHEN sp.SalesYTD / NULLIF(sp.SalesQuota, 0) >= 0.75 THEN 'Near Target (75-99%)'
        ELSE 'Below Target (<75%)'
    END AS performance_tier,
    RANK() OVER (ORDER BY sp.SalesYTD DESC) AS sales_rank
FROM salesperson sp
LEFT JOIN person p          ON sp.BusinessEntityID = p.BusinessEntityID
LEFT JOIN salesterritory st ON sp.TerritoryID = st.TerritoryID
ORDER BY attainment_pct DESC NULLS LAST;