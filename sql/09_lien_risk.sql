USE hmda_credit_risk;

-- Lien status credit risk analysis

SELECT
    lien_status,

    CASE lien_status
        WHEN 1 THEN 'First Lien'
        WHEN 2 THEN 'Subordinate Lien'
    END AS lien_status_label,

    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

    SUM(CASE
        WHEN action_taken = 1 THEN 1
        ELSE 0
    END) AS loans_originated,

    SUM(CASE
        WHEN action_taken = 3 THEN 1
        ELSE 0
    END) AS applications_denied,

    ROUND(
        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

WHERE lien_status IN (1, 2)

GROUP BY
    lien_status

ORDER BY
    decisioned_denial_rate DESC;
    
-- Lien status × loan purpose risk analysis

SELECT
    loan_purpose_label,

    lien_status,

    CASE lien_status
        WHEN 1 THEN 'First Lien'
        WHEN 2 THEN 'Subordinate Lien'
    END AS lien_status_label,

    SUM(decisioned) AS decisioned_applications,

    SUM(CASE
        WHEN action_taken = 3 THEN 1
        ELSE 0
    END) AS applications_denied,

    ROUND(
        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

WHERE lien_status IN (1, 2)

GROUP BY
    loan_purpose_label,
    lien_status

HAVING
    SUM(decisioned) >= 10000

ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;