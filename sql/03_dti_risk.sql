USE hmda_credit_risk;

SELECT
    dti_bucket,

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

GROUP BY dti_bucket

ORDER BY
    CASE
        WHEN dti_bucket = '<20%' THEN 1
        WHEN dti_bucket = '20%-<30%' THEN 2
        WHEN dti_bucket = '30%-<36%' THEN 3
        WHEN dti_bucket = '36%-49%' THEN 4
        WHEN dti_bucket = '50%-60%' THEN 5
        WHEN dti_bucket = '>60%' THEN 6
        WHEN dti_bucket = 'Missing' THEN 7
        ELSE 8
    END;
    
    
SELECT
    debt_to_income_ratio,
    dti_bucket,
    COUNT(*) AS applications
FROM hmda_analytical_prod
WHERE dti_bucket = 'Other'
GROUP BY
    debt_to_income_ratio,
    dti_bucket
ORDER BY applications DESC;


UPDATE hmda_analytical_prod
SET dti_bucket =
    CASE
        WHEN debt_to_income_ratio = 'Exempt' THEN 'Exempt'
        WHEN debt_to_income_ratio IS NULL THEN 'Missing'
        WHEN debt_to_income_ratio = '<20%' THEN '<20%'
        WHEN debt_to_income_ratio = '20%-<30%' THEN '20%-<30%'
        WHEN debt_to_income_ratio = '30%-<36%' THEN '30%-<36%'
        WHEN debt_to_income_ratio IN (
            '36', '37', '38', '39', '40', '41',
            '42', '43', '44', '45', '46', '47',
            '48', '49'
        ) THEN '36%-49%'
        WHEN debt_to_income_ratio = '50%-60%' THEN '50%-60%'
        WHEN debt_to_income_ratio = '>60%' THEN '>60%'
        ELSE 'Other'
    END;
    
    
SELECT
    debt_to_income_ratio,
    dti_bucket,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY
    debt_to_income_ratio,
    dti_bucket
ORDER BY
    dti_bucket,
    applications DESC;
    
SELECT
    dti_bucket,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY dti_bucket
ORDER BY applications DESC;


SELECT
    debt_to_income_ratio,
    COUNT(*) AS applications
FROM hmda_analytical_prod
WHERE dti_bucket = 'Other'
GROUP BY debt_to_income_ratio
ORDER BY applications DESC;


SELECT
    SUM(
        CASE
            WHEN debt_to_income_ratio IS NULL THEN 1
            ELSE 0
        END
    ) AS sql_null_count,

    SUM(
        CASE
            WHEN debt_to_income_ratio = '' THEN 1
            ELSE 0
        END
    ) AS empty_string_count,

    SUM(
        CASE
            WHEN TRIM(debt_to_income_ratio) = '' THEN 1
            ELSE 0
        END
    ) AS whitespace_or_empty_count,

    COUNT(*) AS total_rows
FROM hmda_analytical_prod
WHERE dti_bucket = 'Other';


UPDATE hmda_analytical_prod
SET dti_bucket =
    CASE
        WHEN TRIM(debt_to_income_ratio) = '' THEN 'Missing'
        WHEN debt_to_income_ratio = 'Exempt' THEN 'Exempt'
        WHEN debt_to_income_ratio = '<20%' THEN '<20%'
        WHEN debt_to_income_ratio = '20%-<30%' THEN '20%-<30%'
        WHEN debt_to_income_ratio = '30%-<36%' THEN '30%-<36%'
        WHEN debt_to_income_ratio IN (
            '36', '37', '38', '39', '40', '41',
            '42', '43', '44', '45', '46', '47',
            '48', '49'
        ) THEN '36%-49%'
        WHEN debt_to_income_ratio = '50%-60%' THEN '50%-60%'
        WHEN debt_to_income_ratio = '>60%' THEN '>60%'
        ELSE 'Other'
    END;
    
SELECT
    dti_bucket,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY dti_bucket
ORDER BY applications DESC;


USE hmda_credit_risk;

SELECT
    dti_bucket,

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

GROUP BY dti_bucket

ORDER BY
    CASE
        WHEN dti_bucket = '<20%' THEN 1
        WHEN dti_bucket = '20%-<30%' THEN 2
        WHEN dti_bucket = '30%-<36%' THEN 3
        WHEN dti_bucket = '36%-49%' THEN 4
        WHEN dti_bucket = '50%-60%' THEN 5
        WHEN dti_bucket = '>60%' THEN 6
        WHEN dti_bucket = 'Missing' THEN 7
        WHEN dti_bucket = 'Exempt' THEN 8
        ELSE 9
    END;