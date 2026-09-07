USE hmda_credit_risk;

SELECT
    ltv_quality_flag,
    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

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

GROUP BY ltv_quality_flag

ORDER BY
    CASE
        WHEN ltv_quality_flag = 'Valid' THEN 1
        WHEN ltv_quality_flag = 'High >100%' THEN 2
        WHEN ltv_quality_flag = 'Extreme >1000%' THEN 3
        WHEN ltv_quality_flag = 'Missing' THEN 4
        ELSE 5
    END;
    
USE hmda_credit_risk;

SELECT
    ltv_bucket,

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

WHERE ltv_quality_flag <> 'Extreme >1000%'

GROUP BY ltv_bucket

ORDER BY
    CASE
        WHEN ltv_bucket = '<=60%' THEN 1
        WHEN ltv_bucket = '60-80%' THEN 2
        WHEN ltv_bucket = '80-90%' THEN 3
        WHEN ltv_bucket = '90-100%' THEN 4
        WHEN ltv_bucket = '>100%' THEN 5
        WHEN ltv_bucket = 'Missing' THEN 6
        ELSE 7
    END;
    
    
USE hmda_credit_risk;

SELECT
    loan_purpose_label,
    ltv_bucket,

    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

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

WHERE ltv_quality_flag <> 'Extreme >1000%'
  AND ltv_bucket <> 'Missing'

GROUP BY
    loan_purpose_label,
    ltv_bucket

ORDER BY
    loan_purpose_label,
    CASE
        WHEN ltv_bucket = '<=60%' THEN 1
        WHEN ltv_bucket = '60-80%' THEN 2
        WHEN ltv_bucket = '80-90%' THEN 3
        WHEN ltv_bucket = '90-100%' THEN 4
        WHEN ltv_bucket = '>100%' THEN 5
        ELSE 6
    END;