USE hmda_credit_risk;

SELECT
    applicant_ethnicity_1,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
GROUP BY applicant_ethnicity_1
ORDER BY applicant_ethnicity_1;

USE hmda_credit_risk;

SELECT
    CASE
        WHEN applicant_ethnicity_1 IN (1, 11, 12, 13, 14)
            THEN 'Hispanic / Latino'

        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'

        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'

        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'

        WHEN applicant_ethnicity_1 IS NULL
            THEN 'Missing'

        ELSE 'Other'
    END AS ethnicity_group,

    COUNT(*) AS total_applications,

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
    CASE
        WHEN applicant_ethnicity_1 IN (1, 11, 12, 13, 14)
            THEN 'Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'
        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'
        WHEN applicant_ethnicity_1 IS NULL
            THEN 'Missing'
        ELSE 'Other'
    END
ORDER BY decisioned_denial_rate DESC;

USE hmda_credit_risk;

SELECT
    CASE
        WHEN applicant_ethnicity_1 IN (1, 11, 12, 13, 14)
            THEN 'Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'
        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'
        WHEN applicant_ethnicity_1 IS NULL
            THEN 'Missing'
        ELSE 'Other'
    END AS ethnicity_group,

    loan_purpose_label,

    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        AS applications_denied,

    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod
WHERE applicant_ethnicity_1 IN (1, 11, 12, 13, 14, 2, 3, 4)
GROUP BY
    CASE
        WHEN applicant_ethnicity_1 IN (1, 11, 12, 13, 14)
            THEN 'Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'
        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'
        ELSE 'Missing'
    END,
    loan_purpose_label
ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;
    
USE hmda_credit_risk;

SELECT
    ethnicity_group,
    loan_purpose_label,

    COUNT(*) AS total_applications,

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

FROM (
    SELECT
        CASE
            WHEN applicant_ethnicity_1 IN (1, 11, 12, 13, 14)
                THEN 'Hispanic / Latino'
            WHEN applicant_ethnicity_1 = 2
                THEN 'Not Hispanic / Latino'
            WHEN applicant_ethnicity_1 = 3
                THEN 'Information Not Provided'
            WHEN applicant_ethnicity_1 = 4
                THEN 'Not Applicable'
            WHEN applicant_ethnicity_1 IS NULL
                THEN 'Missing'
            ELSE 'Other'
        END AS ethnicity_group,
        loan_purpose_label,
        decisioned,
        action_taken
    FROM hmda_analytical_prod
) AS x
GROUP BY
    ethnicity_group,
    loan_purpose_label
ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;
    
USE hmda_credit_risk;

WITH purpose_rates AS (

    SELECT
        loan_purpose_label,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                THEN 1 ELSE 0
            END
        ) AS hispanic_decisioned,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        ) AS hispanic_denied,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                THEN 1 ELSE 0
            END
        ) AS non_hispanic_decisioned,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        ) AS non_hispanic_denied

    FROM hmda_analytical_prod

    WHERE applicant_ethnicity_1 IN
        (1,11,12,13,14,2)

    GROUP BY loan_purpose_label
),

purpose_mix AS (

    SELECT
        loan_purpose_label,

        non_hispanic_decisioned
        / SUM(non_hispanic_decisioned) OVER ()
        AS common_weight

    FROM purpose_rates
)

SELECT
    ROUND(
        SUM(
            hispanic_denied
            / NULLIF(hispanic_decisioned,0)
            * common_weight
        ) * 100,
        2
    ) AS standardized_hispanic_denial_rate,

    ROUND(
        SUM(
            non_hispanic_denied
            / NULLIF(non_hispanic_decisioned,0)
            * common_weight
        ) * 100,
        2
    ) AS standardized_non_hispanic_denial_rate,

    ROUND(
        (
            SUM(
                hispanic_denied
                / NULLIF(hispanic_decisioned,0)
                * common_weight
            )
            -
            SUM(
                non_hispanic_denied
                / NULLIF(non_hispanic_decisioned,0)
                * common_weight
            )
        ) * 100,
        2
    ) AS standardized_gap_pp

FROM purpose_rates
JOIN purpose_mix USING (loan_purpose_label);

USE hmda_credit_risk;

SELECT
    loan_purpose_label,
    CASE
        WHEN loan_type = 1 THEN 'Conventional'
        WHEN loan_type = 2 THEN 'FHA'
        WHEN loan_type = 3 THEN 'VA'
        WHEN loan_type = 4 THEN 'USDA'
        ELSE 'Other'
    END AS loan_type_label,

    COUNT(*) AS decisioned_applications,

    ROUND(
        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                    THEN 1 ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS hispanic_denial_rate,

    ROUND(
        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        )
        /
        NULLIF(
            SUM(
                CASE
                    WHEN applicant_ethnicity_1 = 2
                    THEN 1 ELSE 0
                END
            ), 0
        ) * 100,
        2
    ) AS non_hispanic_denial_rate

FROM hmda_analytical_prod

WHERE
    applicant_ethnicity_1 IN (1,11,12,13,14,2)
    AND decisioned = 1
GROUP BY
    loan_purpose_label,
    loan_type
HAVING
    SUM(
        CASE
            WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
            THEN 1 ELSE 0
        END
    ) >= 10000
    AND
    SUM(
        CASE
            WHEN applicant_ethnicity_1 = 2
            THEN 1 ELSE 0
        END
    ) >= 10000
ORDER BY
    loan_purpose_label,
    loan_type;
    
USE hmda_credit_risk;

WITH segment_rates AS (

    SELECT
        loan_purpose_label,
        loan_type,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                THEN 1 ELSE 0
            END
        ) AS hispanic_decisioned,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        ) AS hispanic_denied,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                THEN 1 ELSE 0
            END
        ) AS non_hispanic_decisioned,

        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                     AND action_taken = 3
                THEN 1 ELSE 0
            END
        ) AS non_hispanic_denied

    FROM hmda_analytical_prod

    WHERE applicant_ethnicity_1 IN
        (1,11,12,13,14,2)

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING
        SUM(
            CASE
                WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
                THEN 1 ELSE 0
            END
        ) >= 10000

        AND

        SUM(
            CASE
                WHEN applicant_ethnicity_1 = 2
                THEN 1 ELSE 0
            END
        ) >= 10000
),

benchmark_weights AS (

    SELECT
        loan_purpose_label,
        loan_type,

        non_hispanic_decisioned
        /
        SUM(non_hispanic_decisioned) OVER ()
        AS common_weight

    FROM segment_rates
)

SELECT

    ROUND(
        SUM(
            hispanic_denied
            / NULLIF(hispanic_decisioned,0)
            * common_weight
        ) * 100,
        2
    ) AS standardized_hispanic_denial_rate,

    ROUND(
        SUM(
            non_hispanic_denied
            / NULLIF(non_hispanic_decisioned,0)
            * common_weight
        ) * 100,
        2
    ) AS standardized_non_hispanic_denial_rate,
    ROUND(
        (
            SUM(
                hispanic_denied
                / NULLIF(hispanic_decisioned,0)
                * common_weight
            )
            SUM(
                non_hispanic_denied
                / NULLIF(non_hispanic_decisioned,0)
                * common_weight
            )
        ) * 100,
        2
    ) AS standardized_gap_pp
FROM segment_rates
JOIN benchmark_weights
    USING (loan_purpose_label, loan_type);
    
