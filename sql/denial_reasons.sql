USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_denial_reason_risk AS

SELECT
    denial_reason_code,
    CASE denial_reason_code
        WHEN 1 THEN 'Debt-to-income ratio'
        WHEN 2 THEN 'Employment history'
        WHEN 3 THEN 'Credit history'
        WHEN 4 THEN 'Collateral'
        WHEN 5 THEN 'Insufficient cash'
        WHEN 6 THEN 'Unverifiable information'
        WHEN 7 THEN 'Credit application incomplete'
        WHEN 8 THEN 'Mortgage insurance denied'
        WHEN 9 THEN 'Other'
        WHEN 10 THEN 'Not applicable'
        WHEN 1111 THEN 'Exempt'
        ELSE 'Unknown'
    END AS denial_reason,
    COUNT(*) AS reason_occurrences
FROM
(
    SELECT denial_reason_1 AS denial_reason_code
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_1 IS NOT NULL

    UNION ALL

    SELECT denial_reason_2
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_2 IS NOT NULL

    UNION ALL

    SELECT denial_reason_3
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_3 IS NOT NULL

    UNION ALL

    SELECT denial_reason_4
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_4 IS NOT NULL
) AS reasons
GROUP BY
    denial_reason_code
ORDER BY
    reason_occurrences DESC;
    
SELECT *
FROM vw_denial_reason_risk;


CREATE OR REPLACE VIEW vw_dti_ltv_risk AS
SELECT
    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
    ltv_bucket,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
WHERE decisioned = 1
  AND dti_bucket IS NOT NULL
  AND TRIM(dti_bucket) <> ''
  AND ltv_quality_flag IN ('Valid', 'High >100%')
GROUP BY
    REPLACE(TRIM(dti_bucket), CHAR(13), ''),
    ltv_bucket;
    

SELECT *
FROM vw_dti_ltv_risk
ORDER BY dti_bucket, ltv_bucket;

CREATE OR REPLACE VIEW vw_dti_ltv_risk AS
SELECT
    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
    ltv_bucket,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
WHERE decisioned = 1
  AND dti_bucket IS NOT NULL
  AND TRIM(dti_bucket) <> ''
  AND REPLACE(TRIM(dti_bucket), CHAR(13), '') NOT IN ('Missing', 'Exempt')
  AND ltv_quality_flag IN ('Valid', 'High >100%')
GROUP BY
    REPLACE(TRIM(dti_bucket), CHAR(13), ''),
    ltv_bucket;
    
SELECT *
FROM vw_dti_ltv_risk
ORDER BY dti_bucket, ltv_bucket;