USE hmda_credit_risk;

WITH national AS (

    SELECT
        SUM(decisioned) AS national_decisioned,

        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) AS national_denied

    FROM hmda_analytical_prod

),

state_risk AS (

    SELECT
        state_code,

        SUM(decisioned) AS decisioned_applications,

        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) AS applications_denied

    FROM hmda_analytical_prod

    GROUP BY state_code

)

SELECT

    state_code,

    decisioned_applications,

    applications_denied,

    ROUND(
        applications_denied
        / NULLIF(decisioned_applications, 0) * 100,
        2
    ) AS state_denial_rate,

    ROUND(
        national_denied
        / NULLIF(national_decisioned, 0) * 100,
        2
    ) AS national_denial_rate,

    ROUND(
        (
            applications_denied
            / NULLIF(decisioned_applications, 0)
            -
            national_denied
            / NULLIF(national_decisioned, 0)
        ) * 100,
        2
    ) AS denial_rate_gap_pp,

    ROUND(
        applications_denied
        -
        (
            decisioned_applications
            *
            national_denied
            / NULLIF(national_decisioned, 0)
        ),
        0
    ) AS excess_denials_vs_national

FROM state_risk
CROSS JOIN national

WHERE decisioned_applications >= 10000

ORDER BY
    excess_denials_vs_national DESC;
    
    
USE hmda_credit_risk;

SELECT
    state_code,

    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,

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
    AND state_code IS NOT NULL

    AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
        '<20%',
        '20%-<30%',
        '30%-<36%',
        '36%-49%',
        '50%-60%',
        '>60%'
    )

    AND state_code IN (
        'FL',
        'TX',
        'GA',
        'LA',
        'CA',
        'MS',
        'NJ',
        'AL',
        'NY'
    )

GROUP BY
    state_code,
    REPLACE(TRIM(dti_bucket), CHAR(13), '')

HAVING
    COUNT(*) >= 10000

ORDER BY
    state_code,
    CASE REPLACE(TRIM(dti_bucket), CHAR(13), '')
        WHEN '<20%' THEN 1
        WHEN '20%-<30%' THEN 2
        WHEN '30%-<36%' THEN 3
        WHEN '36%-49%' THEN 4
        WHEN '50%-60%' THEN 5
        WHEN '>60%' THEN 6
    END;
    
    
USE hmda_credit_risk;

WITH state_dti AS (

    SELECT
        state_code,

        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,

        COUNT(*) AS decisioned_applications,

        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) AS applications_denied

    FROM hmda_analytical_prod

    WHERE
        decisioned = 1
        AND state_code IN ('CA','FL','GA','NY','TX')

        AND REPLACE(TRIM(dti_bucket), CHAR(13), '') IN (
            '<20%',
            '20%-<30%',
            '30%-<36%',
            '36%-49%',
            '50%-60%',
            '>60%'
        )

    GROUP BY
        state_code,
        REPLACE(TRIM(dti_bucket), CHAR(13), '')

    HAVING COUNT(*) >= 10000
),

complete_states AS (

    SELECT
        state_code
    FROM state_dti
    GROUP BY state_code
    HAVING COUNT(*) = 6
),

national_dti AS (

    SELECT
        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,

        COUNT(*) AS decisioned_applications

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

    GROUP BY
        REPLACE(TRIM(dti_bucket), CHAR(13), '')
),

weights AS (

    SELECT
        dti_bucket,

        decisioned_applications
        / SUM(decisioned_applications) OVER ()
        AS common_weight

    FROM national_dti
)
SELECT
    s.state_code,
    ROUND(
        SUM(
            s.applications_denied
            / NULLIF(s.decisioned_applications, 0)
            * w.common_weight
        ) * 100,
        2
    ) AS standardized_dti_denial_rate
FROM state_dti s
JOIN complete_states c
    ON s.state_code = c.state_code
JOIN weights w
    ON s.dti_bucket = w.dti_bucket
GROUP BY
    s.state_code
ORDER BY
    standardized_dti_denial_rate DESC;
    

USE hmda_credit_risk;

SELECT
    loan_purpose_label,

    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

    SUM(
        CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END
    ) AS applications_denied,

    ROUND(
        SUM(decisioned)
        / SUM(SUM(decisioned)) OVER () * 100,
        2
    ) AS decisioned_volume_share_pct,
    ROUND(
        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        )
        / NULLIF(SUM(decisioned),0) * 100,
        2
    ) AS decisioned_denial_rate,
    ROUND(
        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                SUM(
                    CASE
                        WHEN action_taken = 3 THEN 1
                        ELSE 0
                    END
                )
            ) OVER (),
            0
        ) * 100,
        2
    ) AS share_of_all_denials_pct
FROM hmda_analytical_prod
GROUP BY
    loan_purpose_label
ORDER BY
    applications_denied DESC;