USE hmda_credit_risk;

-- Applicant age and observed decision outcomes
-- Descriptive analysis only; not a causal risk assessment

SELECT
    applicant_age,

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

WHERE applicant_age IS NOT NULL
  AND TRIM(applicant_age) <> ''

GROUP BY
    applicant_age

ORDER BY
    decisioned_denial_rate DESC;
    
-- Applicant age × loan purpose
-- Descriptive fair-lending analysis; not a causal risk assessment

SELECT
    loan_purpose_label,

    applicant_age,

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

WHERE applicant_age IS NOT NULL
  AND TRIM(applicant_age) <> ''

GROUP BY
    loan_purpose_label,
    applicant_age

HAVING
    SUM(decisioned) >= 10000

ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;
    
-- Applicant age × loan purpose × loan type
-- Descriptive fair-lending analysis.
-- Minimum 10,000 decisioned applications per segment.

SELECT
    loan_purpose_label,

    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    applicant_age,

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
        )
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

WHERE applicant_age IS NOT NULL
  AND TRIM(applicant_age) <> ''
  AND loan_purpose_label IS NOT NULL
  AND loan_type IN (1, 2, 3, 4)

GROUP BY
    loan_purpose_label,
    loan_type,
    applicant_age

HAVING
    SUM(decisioned) >= 10000

ORDER BY
    loan_purpose_label,
    loan_type,
    decisioned_denial_rate DESC;
    

-- Age disparity range within loan-purpose × loan-type segments
-- Descriptive fair-lending analysis only.
-- Measures variation across age groups without implying causality.

WITH age_segment_rates AS (
    SELECT
        loan_purpose_label,
        loan_type,

        CASE loan_type
            WHEN 1 THEN 'Conventional'
            WHEN 2 THEN 'FHA'
            WHEN 3 THEN 'VA'
            WHEN 4 THEN 'USDA / RHS'
        END AS loan_type_label,

        applicant_age,

        SUM(decisioned) AS decisioned_applications,

        ROUND(
            SUM(
                CASE
                    WHEN action_taken = 3 THEN 1
                    ELSE 0
                END
            )
            / NULLIF(SUM(decisioned), 0) * 100,
            2
        ) AS denial_rate

    FROM hmda_analytical_prod

    WHERE applicant_age IN (
        '<25',
        '25-34',
        '35-44',
        '45-54',
        '55-64',
        '65-74',
        '>74'
    )

    GROUP BY
        loan_purpose_label,
        loan_type,
        applicant_age

    HAVING
        SUM(decisioned) >= 10000
)

SELECT
    loan_purpose_label,
    loan_type,
    loan_type_label,

    MIN(denial_rate) AS lowest_age_denial_rate,

    MAX(denial_rate) AS highest_age_denial_rate,

    ROUND(
        MAX(denial_rate) - MIN(denial_rate),
        2
    ) AS age_denial_rate_range_pp,

    SUM(decisioned_applications) AS decisioned_applications_across_age_groups,

    COUNT(*) AS age_groups_meeting_threshold

FROM age_segment_rates

GROUP BY
    loan_purpose_label,
    loan_type,
    loan_type_label

HAVING
    COUNT(*) >= 4

ORDER BY
    age_denial_rate_range_pp DESC;
    
-- Standardized age denial-rate comparison
-- Applies a common loan-purpose × loan-type mix across age groups.
-- Descriptive fair-lending analysis only; not causal.

WITH segment_age AS (
    SELECT
        loan_purpose_label,
        loan_type,
        applicant_age,

        SUM(decisioned) AS decisioned_applications,

        SUM(
            CASE
                WHEN action_taken = 3 THEN 1
                ELSE 0
            END
        ) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_age IN (
        '<25',
        '25-34',
        '35-44',
        '45-54',
        '55-64',
        '65-74',
        '>74'
    )
    AND loan_purpose_label IS NOT NULL
    AND loan_type IN (1,2,3,4)

    GROUP BY
        loan_purpose_label,
        loan_type,
        applicant_age
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM segment_age

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING
        COUNT(DISTINCT applicant_age) = 7
        AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT
        s.*
    FROM segment_age s

    INNER JOIN eligible_segments e
        ON s.loan_purpose_label = e.loan_purpose_label
       AND s.loan_type = e.loan_type
),

segment_weights AS (
    SELECT
        loan_purpose_label,
        loan_type,

        SUM(decisioned_applications) AS segment_decisioned,

        SUM(SUM(decisioned_applications))
            OVER () AS total_segment_decisioned

    FROM common_segments

    GROUP BY
        loan_purpose_label,
        loan_type
)

SELECT
    c.applicant_age,

    ROUND(
        SUM(
            (
                c.applications_denied * 100.0
                / NULLIF(c.decisioned_applications, 0)
            )
            *
            (
                w.segment_decisioned * 1.0
                / NULLIF(w.total_segment_decisioned, 0)
            )
        ),
        2
    ) AS standardized_denial_rate,

    COUNT(*) AS standardized_segments

FROM common_segments c

INNER JOIN segment_weights w
    ON c.loan_purpose_label = w.loan_purpose_label
   AND c.loan_type = w.loan_type

GROUP BY
    c.applicant_age

ORDER BY
    standardized_denial_rate DESC;
    
-- Identify the common-support segments used in standardized age analysis

WITH segment_age AS (
    SELECT
        loan_purpose_label,
        loan_type,
        applicant_age,
        SUM(decisioned) AS decisioned_applications
    FROM hmda_analytical_prod
    WHERE applicant_age IN ('<25','25-34','35-44','45-54','55-64','65-74','>74')
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)
    GROUP BY
        loan_purpose_label,
        loan_type,
        applicant_age
)

SELECT
    loan_purpose_label,
    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,
    COUNT(DISTINCT applicant_age) AS age_groups,
    MIN(decisioned_applications) AS minimum_age_group_decisioned,
    SUM(decisioned_applications) AS total_decisioned
FROM segment_age
GROUP BY
    loan_purpose_label,
    loan_type
HAVING COUNT(DISTINCT applicant_age) = 7
   AND MIN(decisioned_applications) >= 10000
ORDER BY total_decisioned DESC;

-- Final age robustness table
SELECT
    loan_purpose_label,
    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 3 THEN 'VA'
    END AS loan_type_label,
    applicant_age,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
WHERE loan_purpose_label = 'Home Purchase'
  AND loan_type IN (1,3)
  AND applicant_age IN ('<25','25-34','35-44','45-54','55-64','65-74','>74')
GROUP BY
    loan_purpose_label,
    loan_type,
    applicant_age
ORDER BY
    loan_type,
    FIELD(
        applicant_age,
        '<25','25-34','35-44','45-54','55-64','65-74','>74'
    );