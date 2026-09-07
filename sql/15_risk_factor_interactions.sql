USE hmda_credit_risk;

SELECT
    dti_bucket,
    ltv_bucket,
    COUNT(*) AS decisioned_applications,
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
        )
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS decisioned_denial_rate\
FROM hmda_analytical_prod
WHERE
    decisioned = 1
    -- Focus on reported DTI values
    AND dti_bucket IN (
        '<20',
        '20-<30',
        '30-<36',
        '36-49',
        '50-60',
        '>60'
    )
    -- Exclude missing and extreme LTV values
    AND ltv_quality_flag IN (
        'Valid',
        'High >100%'
    )
GROUP BY
    dti_bucket,
    ltv_bucket
ORDER BY
    CASE dti_bucket
        WHEN '<20' THEN 1
        WHEN '20-<30' THEN 2
        WHEN '30-<36' THEN 3
        WHEN '36-49' THEN 4
        WHEN '50-60' THEN 5
        WHEN '>60' THEN 6
    END,
    CASE ltv_bucket
        WHEN '<=60' THEN 1
        WHEN '60-80' THEN 2
        WHEN '80-90' THEN 3
        WHEN '90-100' THEN 4
        WHEN '>100' THEN 5
    END;
    
    
USE hmda_credit_risk;

SELECT
    'DTI_BUCKET' AS field_name,
    dti_bucket AS field_value,
    COUNT(*) AS row_count
FROM hmda_analytical_prod
GROUP BY dti_bucket

UNION ALL

SELECT
    'LTV_BUCKET' AS field_name,
    ltv_bucket AS field_value,
    COUNT(*) AS row_count
FROM hmda_analytical_prod
GROUP BY ltv_bucket
UNION ALL
SELECT
    'LTV_QUALITY_FLAG' AS field_name,
    ltv_quality_flag AS field_value,
    COUNT(*) AS row_count
FROM hmda_analytical_prod
GROUP BY ltv_quality_flag
ORDER BY field_name, field_value;

USE hmda_credit_risk;

SELECT
    dti_bucket,
    ltv_bucket,
    decisioned_applications,
    applications_denied,
    decisioned_denial_rate

FROM (

    SELECT
        TRIM(dti_bucket) AS dti_bucket,
        TRIM(ltv_bucket) AS ltv_bucket,

        COUNT(*) AS decisioned_applications,

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
            )
            / NULLIF(COUNT(*), 0) * 100,
            2
        ) AS decisioned_denial_rate

    FROM hmda_analytical_prod

    WHERE
        decisioned = 1

        AND TRIM(dti_bucket) IN (
            '<20%',
            '20%-<30%',
            '30%-<36%',
            '36%-49%',
            '50%-60%',
            '>60%'
        )

        AND ltv_quality_flag IN (
            'Valid',
            'High >100%'
        )

        AND TRIM(ltv_bucket) IN (
            '<=60%',
            '60%-80%',
            '80%-90%',
            '90%-100%',
            '>100%'
        )

    GROUP BY
        TRIM(dti_bucket),
        TRIM(ltv_bucket)

) AS risk_matrix

ORDER BY
    CASE dti_bucket
        WHEN '<20%' THEN 1
        WHEN '20%-<30%' THEN 2
        WHEN '30%-<36%' THEN 3
        WHEN '36%-49%' THEN 4
        WHEN '50%-60%' THEN 5
        WHEN '>60%' THEN 6
    END,

    CASE ltv_bucket
        WHEN '<=60%' THEN 1
        WHEN '60%-80%' THEN 2
        WHEN '80%-90%' THEN 3
        WHEN '90%-100%' THEN 4
        WHEN '>100%' THEN 5
    END;
    
    USE hmda_credit_risk;

SELECT
    CONCAT('[', ltv_quality_flag, ']') AS ltv_quality_flag_exact,
    COUNT(*) AS row_count
FROM hmda_analytical_prod
GROUP BY ltv_quality_flag
ORDER BY row_count DESC;

USE hmda_credit_risk;

SELECT
    CONCAT(
        '[',
        REPLACE(TRIM(ltv_bucket), CHAR(13), ''),
        ']'
    ) AS clean_ltv_bucket,
    COUNT(*) AS row_count

FROM hmda_analytical_prod

GROUP BY
    REPLACE(TRIM(ltv_bucket), CHAR(13), '')

ORDER BY
    row_count DESC;
    
SET SESSION sql_mode = REPLACE(
    @@SESSION.sql_mode,
    'ONLY_FULL_GROUP_BY',
    ''
);

USE hmda_credit_risk;

SELECT
    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
    REPLACE(TRIM(ltv_bucket), CHAR(13), '') AS ltv_bucket,

    COUNT(*) AS decisioned_applications,

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
        )
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

WHERE
    decisioned = 1

    AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
        '<20%',
        '20%-<30%',
        '30%-<36%',
        '36%-49%',
        '50%-60%',
        '>60%'
    )

    AND ltv_quality_flag IN (
        'Valid',
        'High >100%'
    )

    AND REPLACE(TRIM(ltv_bucket), CHAR(13), '') IN (
        '<=60%',
        '60%-80%',
        '80%-90%',
        '90%-100%',
        '>100%'
    )

GROUP BY
    REPLACE(TRIM(dti_bucket), CHAR(13), ''),
    REPLACE(TRIM(ltv_bucket), CHAR(13), '')

ORDER BY
    CASE REPLACE(TRIM(dti_bucket), CHAR(13), '')
        WHEN '<20%' THEN 1
        WHEN '20%-<30%' THEN 2
        WHEN '30%-<36%' THEN 3
        WHEN '36%-49%' THEN 4
        WHEN '50%-60%' THEN 5
        WHEN '>60%' THEN 6
    END,

    CASE REPLACE(TRIM(ltv_bucket), CHAR(13), '')
        WHEN '<=60%' THEN 1
        WHEN '60%-80%' THEN 2
        WHEN '80%-90%' THEN 3
        WHEN '90%-100%' THEN 4
        WHEN '>100%' THEN 5
    END;
    
USE hmda_credit_risk;

SELECT
    dti_bucket,

    COUNT(*) AS ltv_segments,

    MIN(decisioned_denial_rate) AS lowest_ltv_denial_rate,

    MAX(decisioned_denial_rate) AS highest_ltv_denial_rate,

    ROUND(
        MAX(decisioned_denial_rate)
        - MIN(decisioned_denial_rate),
        2
    ) AS ltv_rate_range_pp

FROM (
    SELECT
        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
        REPLACE(TRIM(ltv_bucket), CHAR(13), '') AS ltv_bucket,

        COUNT(*) AS decisioned_applications,

        ROUND(
            SUM(
                CASE WHEN action_taken = 3 THEN 1 ELSE 0 END
            )
            / NULLIF(COUNT(*), 0) * 100,
            2
        ) AS decisioned_denial_rate

    FROM hmda_analytical_prod

    WHERE
        decisioned = 1

        AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
            '<20%',
            '20%-<30%',
            '30%-<36%',
            '36%-49%',
            '50%-60%',
            '>60%'
        )

        AND ltv_quality_flag IN (
            'Valid',
            'High >100%'
        )

        AND REPLACE(TRIM(ltv_bucket), CHAR(13), '') IN (
            '<=60%',
            '60%-80%',
            '80%-90%',
            '90%-100%',
            '>100%'
        )

    GROUP BY
        REPLACE(TRIM(dti_bucket), CHAR(13), ''),
        REPLACE(TRIM(ltv_bucket), CHAR(13), '')
) AS matrix

GROUP BY
    dti_bucket;
    
SELECT
    ltv_bucket,

    COUNT(*) AS dti_segments,

    MIN(decisioned_denial_rate) AS lowest_dti_denial_rate,

    MAX(decisioned_denial_rate) AS highest_dti_denial_rate,

    ROUND(
        MAX(decisioned_denial_rate)
        - MIN(decisioned_denial_rate),
        2
    ) AS dti_rate_range_pp

FROM (
    SELECT
        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
        REPLACE(TRIM(ltv_bucket), CHAR(13), '') AS ltv_bucket,

        COUNT(*) AS decisioned_applications,

        ROUND(
            SUM(
                CASE WHEN action_taken = 3 THEN 1 ELSE 0 END
            )
            / NULLIF(COUNT(*), 0) * 100,
            2
        ) AS decisioned_denial_rate

    FROM hmda_analytical_prod

    WHERE
        decisioned = 1

        AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
            '<20%',
            '20%-<30%',
            '30%-<36%',
            '36%-49%',
            '50%-60%',
            '>60%'
        )

        AND ltv_quality_flag IN (
            'Valid',
            'High >100%'
        )

        AND REPLACE(TRIM(ltv_bucket), CHAR(13), '') IN (
            '<=60%',
            '60%-80%',
            '80%-90%',
            '90%-100%',
            '>100%'
        )

    GROUP BY
        REPLACE(TRIM(dti_bucket), CHAR(13), ''),
        REPLACE(TRIM(ltv_bucket), CHAR(13), '')
) AS matrix

GROUP BY
    ltv_bucket;
    
-- ============================================================
-- High-Risk DTI × LTV Segments
-- Minimum 10,000 decisioned applications
-- ============================================================

SELECT
    dti_bucket,
    ltv_bucket,
    decisioned_applications,
    applications_denied,
    decisioned_denial_rate
FROM (
    SELECT
        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
        REPLACE(TRIM(ltv_bucket), CHAR(13), '') AS ltv_bucket,
        COUNT(*) AS decisioned_applications,

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
            )
            / NULLIF(COUNT(*), 0) * 100,
            2
        ) AS decisioned_denial_rate

    FROM hmda_analytical_prod

    WHERE
        decisioned = 1

        AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
            '<20%',
            '20%-<30%',
            '30%-<36%',
            '36%-49%',
            '50%-60%',
            '>60%'
        )

        AND ltv_quality_flag IN (
            'Valid',
            'High >100%'
        )

        AND REPLACE(TRIM(ltv_bucket), CHAR(13), '') IN (
            '<=60%',
            '60%-80%',
            '80%-90%',
            '90%-100%',
            '>100%'
        )
    GROUP BY
        REPLACE(TRIM(dti_bucket), CHAR(13), ''),
        REPLACE(TRIM(ltv_bucket), CHAR(13), '')
) AS risk_segments
WHERE decisioned_applications >= 10000
ORDER BY
    decisioned_denial_rate DESC;