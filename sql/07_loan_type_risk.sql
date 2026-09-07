USE hmda_credit_risk;

-- Loan type credit risk analysis

SELECT
    loan_type,
    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

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

GROUP BY
    loan_type

ORDER BY
    decisioned_denial_rate DESC;
    
    
-- Loan type × loan purpose risk analysis

SELECT
    loan_purpose_label,

    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

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

GROUP BY
    loan_purpose_label,
    loan_type

HAVING
    SUM(decisioned) >= 1000

ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;
    
    
-- Loan type × loan purpose
-- Focused on combinations with meaningful decision volume

SELECT
    loan_purpose_label,

    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

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

GROUP BY
    loan_purpose_label,
    loan_type

HAVING
    SUM(decisioned) >= 10000

ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;