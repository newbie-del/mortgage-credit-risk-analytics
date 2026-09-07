USE hmda_credit_risk;

SELECT
    applicant_sex,
    CASE applicant_sex
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
        WHEN 3 THEN 'Information Not Provided'
        WHEN 4 THEN 'Not Applicable'
        WHEN 6 THEN 'Male and Female'
    END AS applicant_sex_label,

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
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

WHERE applicant_sex IN (1,2,3,4,6)

GROUP BY
    applicant_sex

ORDER BY
    decisioned_denial_rate DESC;
    
    
USE hmda_credit_risk;

SELECT
    loan_purpose_label,

    applicant_sex,

    CASE applicant_sex
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
        WHEN 3 THEN 'Information Not Provided'
        WHEN 4 THEN 'Not Applicable'
        WHEN 6 THEN 'Male and Female'
    END AS applicant_sex_label,

    COUNT(*) AS total_applications,

    SUM(decisioned) AS decisioned_applications,

    SUM(CASE
        WHEN action_taken = 3 THEN 1
        ELSE 0
    END) AS applications_denied,

    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned),0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

WHERE applicant_sex IN (1,2,3,4,6)
  AND loan_purpose_label IS NOT NULL

GROUP BY
    loan_purpose_label,
    applicant_sex

ORDER BY
    loan_purpose_label,
    denial_rate DESC;
    
    
USE hmda_credit_risk;

WITH sex_purpose AS (
    SELECT
        loan_purpose_label,
        applicant_sex,
        SUM(decisioned) AS decisioned_applications,
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied
    FROM hmda_analytical_prod
    WHERE applicant_sex IN (1,2)
      AND loan_purpose_label IS NOT NULL
    GROUP BY
        loan_purpose_label,
        applicant_sex
),

eligible_purposes AS (
    SELECT
        loan_purpose_label
    FROM sex_purpose
    GROUP BY loan_purpose_label
    HAVING COUNT(DISTINCT applicant_sex) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_purposes AS (
    SELECT s.*
    FROM sex_purpose s
    INNER JOIN eligible_purposes e
        ON s.loan_purpose_label = e.loan_purpose_label
),

purpose_weights AS (
    SELECT
        loan_purpose_label,
        SUM(decisioned_applications) AS purpose_decisioned,
        SUM(SUM(decisioned_applications)) OVER () AS total_decisioned
    FROM common_purposes
    GROUP BY loan_purpose_label
)

SELECT
    CASE c.applicant_sex
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
    END AS applicant_sex_label,

    ROUND(
        SUM(
            (
                c.applications_denied * 100.0
                / NULLIF(c.decisioned_applications,0)
            )
            *
            (
                w.purpose_decisioned * 1.0
                / NULLIF(w.total_decisioned,0)
            )
        ),
        2
    ) AS standardized_denial_rate,

    COUNT(*) AS standardized_purposes

FROM common_purposes c

INNER JOIN purpose_weights w
    ON c.loan_purpose_label = w.loan_purpose_label

GROUP BY c.applicant_sex

ORDER BY standardized_denial_rate DESC;

USE hmda_credit_risk;

WITH sex_segment AS (
    SELECT
        loan_purpose_label,
        loan_type,
        applicant_sex,
        SUM(decisioned) AS decisioned_applications,
        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_sex IN (1,2)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        loan_purpose_label,
        loan_type,
        applicant_sex
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM sex_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT applicant_sex) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT s.*

    FROM sex_segment s

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

    CASE c.applicant_sex
        WHEN 1 THEN 'Male'
        WHEN 2 THEN 'Female'
    END AS applicant_sex_label,

    ROUND(
        SUM(
            (
                c.applications_denied * 100.0
                / NULLIF(c.decisioned_applications,0)
            )
            *
            (
                w.segment_decisioned * 1.0
                / NULLIF(w.total_segment_decisioned,0)
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
    c.applicant_sex

ORDER BY
    standardized_denial_rate DESC;
    
    
USE hmda_credit_risk;

WITH sex_segment AS (
    SELECT
        loan_purpose_label,
        loan_type,
        applicant_sex,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_sex IN (1,2)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        loan_purpose_label,
        loan_type,
        applicant_sex
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM sex_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT applicant_sex) = 2
       AND MIN(decisioned_applications) >= 10000
)

SELECT
    s.loan_purpose_label,

    CASE s.loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,

    MAX(CASE WHEN s.applicant_sex = 2
        THEN s.decisioned_applications END) AS female_decisioned,

    MAX(CASE WHEN s.applicant_sex = 1
        THEN s.decisioned_applications END) AS male_decisioned,

    MAX(CASE WHEN s.applicant_sex = 2
        THEN s.applications_denied * 100.0 /
             NULLIF(s.decisioned_applications,0) END) AS female_denial_rate,

    MAX(CASE WHEN s.applicant_sex = 1
        THEN s.applications_denied * 100.0 /
             NULLIF(s.decisioned_applications,0) END) AS male_denial_rate,

    ROUND(
        MAX(CASE WHEN s.applicant_sex = 2
            THEN s.applications_denied * 100.0 /
                 NULLIF(s.decisioned_applications,0) END)
        -
        MAX(CASE WHEN s.applicant_sex = 1
            THEN s.applications_denied * 100.0 /
                 NULLIF(s.decisioned_applications,0) END),
        2
    ) AS female_minus_male_gap_pp

FROM sex_segment s

INNER JOIN eligible_segments e
    ON s.loan_purpose_label = e.loan_purpose_label
   AND s.loan_type = e.loan_type

GROUP BY
    s.loan_purpose_label,
    s.loan_type

ORDER BY
    female_minus_male_gap_pp DESC;