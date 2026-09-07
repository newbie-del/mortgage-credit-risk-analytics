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
    
    
USE hmda_credit_risk;

SELECT
    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,

    COUNT(*) AS decisioned_applications,

    SUM(
        CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END
    ) AS applications_denied,

    ROUND(
        COUNT(*)
        / SUM(COUNT(*)) OVER () * 100,
        2
    ) AS decisioned_volume_share_pct,

    ROUND(
        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        )
        / NULLIF(COUNT(*), 0) * 100,
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
        SUM(
            SUM(
                CASE
                    WHEN action_taken = 3 THEN 1
                    ELSE 0
                END
            )
        ) OVER () * 100,
        2
    ) AS share_of_all_denials_pct

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

ORDER BY
    CASE REPLACE(TRIM(dti_bucket), CHAR(13), '')
        WHEN '<20%' THEN 1
        WHEN '20%-<30%' THEN 2
        WHEN '30%-<36%' THEN 3
        WHEN '36%-49%' THEN 4
        WHEN '50%-60%' THEN 5
        WHEN '>60%' THEN 6
    END;
    
USE hmda_credit_risk;

SELECT
    dti_bucket,
    loan_purpose_label,

    decisioned_applications,
    applications_denied,

    decisioned_volume_share_pct,
    decisioned_denial_rate,
    share_of_all_denials_pct

FROM (
    SELECT
        REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
        loan_purpose_label,

        COUNT(*) AS decisioned_applications,

        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) AS applications_denied,

        ROUND(
            COUNT(*)
            / SUM(COUNT(*)) OVER () * 100,
            2
        ) AS decisioned_volume_share_pct,

        ROUND(
            SUM(
                CASE
                    WHEN action_taken = 3 THEN 1
                    ELSE 0
                END
            )
            / NULLIF(COUNT(*), 0) * 100,
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
            SUM(
                SUM(
                    CASE
                        WHEN action_taken = 3 THEN 1
                        ELSE 0
                    END
                )
            ) OVER () * 100,
            2
        ) AS share_of_all_denials_pct

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
        REPLACE(TRIM(dti_bucket), CHAR(13), ''),
        loan_purpose_label
) AS segments

ORDER BY
    share_of_all_denials_pct DESC;