USE hmda_credit_risk;

-- State-level credit risk analysis

SELECT
    state_code,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) AS loans_originated,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
WHERE state_code IS NOT NULL
  AND TRIM(state_code) <> ''
GROUP BY state_code
HAVING SUM(decisioned) >= 1000
ORDER BY decisioned_denial_rate DESC;


-- State-level risk with application volume

SELECT
    state_code,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    ROUND(
        SUM(decisioned) * 100.0 /
        COUNT(*),
        2
    ) AS decision_rate_pct,
    SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) AS loans_originated,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
WHERE state_code IS NOT NULL
  AND TRIM(state_code) <> ''
GROUP BY state_code
HAVING SUM(decisioned) >= 1000
ORDER BY total_applications DESC;	


-- State denial rate compared with national benchmark

SELECT
    state_code,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,

    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS state_denial_rate_pct,

    ROUND(
        (
            SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
            / NULLIF(SUM(decisioned), 0)
            -
            (
                SELECT
                    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
                    / NULLIF(SUM(decisioned), 0)
                FROM hmda_analytical_prod
            )
        ) * 100,
        2
    ) AS vs_national_denial_rate_pp

FROM hmda_analytical_prod
WHERE state_code IS NOT NULL
  AND TRIM(state_code) <> ''
GROUP BY state_code
HAVING SUM(decisioned) >= 1000
ORDER BY vs_national_denial_rate_pp DESC;