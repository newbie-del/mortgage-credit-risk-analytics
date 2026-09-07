USE hmda_credit_risk;

SELECT
    loan_purpose_label,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,

    SUM(
        CASE
            WHEN action_taken = 1 THEN 1
            ELSE 0
        END
    ) AS loans_originated,

    SUM(
        CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END
    ) AS applications_denied,

    ROUND(
        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY loan_purpose_label

ORDER BY denial_rate DESC;

SELECT
    loan_purpose,
    loan_purpose_label,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY
    loan_purpose,
    loan_purpose_label
ORDER BY
    loan_purpose IS NULL DESC,
    loan_purpose;
    
UPDATE hmda_analytical_prod
SET loan_purpose_label =
    CASE
        WHEN loan_purpose = 1 THEN 'Home Purchase'
        WHEN loan_purpose = 2 THEN 'Home Improvement'
        WHEN loan_purpose = 31 THEN 'Refinancing'
        WHEN loan_purpose = 32 THEN 'Cash-out Refinancing'
        WHEN loan_purpose = 4 THEN 'Other Purpose'
        WHEN loan_purpose = 5 THEN 'Not Applicable'
        ELSE NULL
    END;
    
    
SELECT
    loan_purpose,
    loan_purpose_label,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY
    loan_purpose,
    loan_purpose_label
ORDER BY
    loan_purpose;
    

USE hmda_credit_risk;

SELECT
    loan_purpose_label,
    
    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

    SUM(
        CASE
            WHEN action_taken = 1 THEN 1
            ELSE 0
        END
    ) AS loans_originated,

    SUM(
        CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END
    ) AS applications_denied,

    ROUND(
        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY loan_purpose_label

ORDER BY denial_rate DESC;