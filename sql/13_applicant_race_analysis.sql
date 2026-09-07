USE hmda_credit_risk;

SELECT
    applicant_race_1,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,

    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

GROUP BY applicant_race_1

ORDER BY total_applications DESC;

USE hmda_credit_risk;

SELECT
    COUNT(*) AS total_records,

    SUM(CASE WHEN applicant_race_1 IS NULL THEN 1 ELSE 0 END)
        AS null_race_1,

    SUM(CASE WHEN applicant_race_1 IN (1,2,3,4,5,6,7)
        THEN 1 ELSE 0 END)
        AS broad_or_status_codes,

    SUM(CASE WHEN applicant_race_1 IN
        (21,22,23,24,25,26,27,41,42,43,44)
        THEN 1 ELSE 0 END)
        AS detailed_race_codes

FROM hmda_analytical_prod;

USE hmda_credit_risk;

SELECT
    applicant_race_1,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,

    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY applicant_race_1

ORDER BY applicant_race_1;

USE hmda_credit_risk;

SELECT
    CASE
        WHEN applicant_race_1 = 1
            THEN 'American Indian or Alaska Native'

        WHEN applicant_race_1 IN
            (2,21,22,23,24,25,26,27)
            THEN 'Asian'

        WHEN applicant_race_1 = 3
            THEN 'Black or African American'

        WHEN applicant_race_1 IN
            (4,41,42,43,44)
            THEN 'Native Hawaiian or Other Pacific Islander'

        WHEN applicant_race_1 = 5
            THEN 'White'

        WHEN applicant_race_1 = 6
            THEN 'Information Not Provided'

        WHEN applicant_race_1 = 7
            THEN 'Not Applicable'

        WHEN applicant_race_1 IS NULL
            THEN 'Blank / Missing'

        ELSE 'Other / Unexpected'
    END AS first_reported_race,

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
        / NULLIF(SUM(decisioned),0) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod

GROUP BY
    CASE
        WHEN applicant_race_1 = 1
            THEN 'American Indian or Alaska Native'
        WHEN applicant_race_1 IN
            (2,21,22,23,24,25,26,27)
            THEN 'Asian'
        WHEN applicant_race_1 = 3
            THEN 'Black or African American'
        WHEN applicant_race_1 IN
            (4,41,42,43,44)
            THEN 'Native Hawaiian or Other Pacific Islander'
        WHEN applicant_race_1 = 5
            THEN 'White'
        WHEN applicant_race_1 = 6
            THEN 'Information Not Provided'
        WHEN applicant_race_1 = 7
            THEN 'Not Applicable'
        WHEN applicant_race_1 IS NULL
            THEN 'Blank / Missing'
        ELSE 'Other / Unexpected'
    END

ORDER BY
    decisioned_denial_rate DESC;
    
    
USE hmda_credit_risk;

SELECT
    CASE
        WHEN applicant_race_1 = 1
            THEN 'American Indian or Alaska Native'
        WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
            THEN 'Asian'
        WHEN applicant_race_1 = 3
            THEN 'Black or African American'
        WHEN applicant_race_1 IN (4,41,42,43,44)
            THEN 'Native Hawaiian or Other Pacific Islander'
        WHEN applicant_race_1 = 5
            THEN 'White'
        WHEN applicant_race_1 = 6
            THEN 'Information Not Provided'
        WHEN applicant_race_1 = 7
            THEN 'Not Applicable'
        WHEN applicant_race_1 IS NULL
            THEN 'Blank / Missing'
        ELSE 'Other / Unexpected'
    END AS first_reported_race,

    loan_purpose_label,

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

WHERE loan_purpose_label IS NOT NULL
  AND applicant_race_1 IN
      (1,2,21,22,23,24,25,26,27,3,4,41,42,43,44,5,6,7)

GROUP BY
    first_reported_race,
    loan_purpose_label

ORDER BY
    loan_purpose_label,
    denial_rate DESC;
    
    
USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        applicant_race_1,
        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN
        (1,2,21,22,23,24,25,26,27,3,4,41,42,43,44,5)

      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        applicant_race_1,
        loan_purpose_label,
        loan_type
),

race_grouped AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 1
                THEN 'American Indian or Alaska Native'
            WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
                THEN 'Asian'
            WHEN applicant_race_1 = 3
                THEN 'Black or African American'
            WHEN applicant_race_1 IN (4,41,42,43,44)
                THEN 'Native Hawaiian or Other Pacific Islander'
            WHEN applicant_race_1 = 5
                THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,
        decisioned_applications,
        applications_denied

    FROM race_segment
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_grouped

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 5
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT r.*

    FROM race_grouped r

    INNER JOIN eligible_segments e
        ON r.loan_purpose_label = e.loan_purpose_label
       AND r.loan_type = e.loan_type
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
    c.race_group,

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
    c.race_group

ORDER BY
    standardized_denial_rate DESC;
    
USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 1
                THEN 'American Indian or Alaska Native'
            WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
                THEN 'Asian'
            WHEN applicant_race_1 = 3
                THEN 'Black or African American'
            WHEN applicant_race_1 IN (4,41,42,43,44)
                THEN 'Native Hawaiian or Other Pacific Islander'
            WHEN applicant_race_1 = 5
                THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN
        (1,2,21,22,23,24,25,26,27,3,4,41,42,43,44,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
)

SELECT
    loan_purpose_label,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,

    MAX(CASE WHEN race_group =
        'American Indian or Alaska Native'
        THEN decisioned_applications ELSE 0 END) AS AIAN,

    MAX(CASE WHEN race_group = 'Asian'
        THEN decisioned_applications ELSE 0 END) AS Asian,

    MAX(CASE WHEN race_group = 'Black or African American'
        THEN decisioned_applications ELSE 0 END) AS Black,

    MAX(CASE WHEN race_group =
        'Native Hawaiian or Other Pacific Islander'
        THEN decisioned_applications ELSE 0 END) AS NHPI,

    MAX(CASE WHEN race_group = 'White'
        THEN decisioned_applications ELSE 0 END) AS White,

    LEAST(
        MAX(CASE WHEN race_group =
            'American Indian or Alaska Native'
            THEN decisioned_applications ELSE 0 END),

        MAX(CASE WHEN race_group = 'Asian'
            THEN decisioned_applications ELSE 0 END),

        MAX(CASE WHEN race_group =
            'Black or African American'
            THEN decisioned_applications ELSE 0 END),

        MAX(CASE WHEN race_group =
            'Native Hawaiian or Other Pacific Islander'
            THEN decisioned_applications ELSE 0 END),

        MAX(CASE WHEN race_group = 'White'
            THEN decisioned_applications ELSE 0 END)
    ) AS minimum_race_group_volume

FROM race_segment

GROUP BY
    loan_purpose_label,
    loan_type

ORDER BY
    minimum_race_group_volume DESC;
    
USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 3 THEN 'Black'
            WHEN applicant_race_1 = 5 THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN (3,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT r.*
    FROM race_segment r

    INNER JOIN eligible_segments e
        ON r.loan_purpose_label = e.loan_purpose_label
       AND r.loan_type = e.loan_type
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
    c.race_group,

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

GROUP BY c.race_group

ORDER BY standardized_denial_rate DESC;

USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 3 THEN 'Black'
            WHEN applicant_race_1 = 5 THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN (3,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
)

SELECT
    r.loan_purpose_label,

    CASE r.loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,

    MAX(CASE WHEN r.race_group = 'Black'
        THEN r.decisioned_applications END) AS black_decisioned,

    MAX(CASE WHEN r.race_group = 'White'
        THEN r.decisioned_applications END) AS white_decisioned,

    ROUND(
        MAX(CASE WHEN r.race_group = 'Black'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS black_denial_rate,

    ROUND(
        MAX(CASE WHEN r.race_group = 'White'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS white_denial_rate,

    ROUND(
        MAX(CASE WHEN r.race_group = 'Black'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END)
        -
        MAX(CASE WHEN r.race_group = 'White'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS black_minus_white_gap_pp

FROM race_segment r

INNER JOIN eligible_segments e
    ON r.loan_purpose_label = e.loan_purpose_label
   AND r.loan_type = e.loan_type

GROUP BY
    r.loan_purpose_label,
    r.loan_type

ORDER BY
    black_minus_white_gap_pp DESC;
    
USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
                THEN 'Asian'
            WHEN applicant_race_1 = 5
                THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
            AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN
        (2,21,22,23,24,25,26,27,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT r.*
    FROM race_segment r

    INNER JOIN eligible_segments e
        ON r.loan_purpose_label = e.loan_purpose_label
       AND r.loan_type = e.loan_type
),

segment_weights AS (
    SELECT
        loan_purpose_label,
        loan_type,
        SUM(decisioned_applications) AS segment_decisioned,
        SUM(SUM(decisioned_applications)) OVER ()
            AS total_segment_decisioned

    FROM common_segments

    GROUP BY
        loan_purpose_label,
        loan_type
)

SELECT
    c.race_group,

    ROUND(
        SUM(
            (
                c.applications_denied * 100.0 /
                NULLIF(c.decisioned_applications,0)
            )
            *
            (
                w.segment_decisioned * 1.0 /
                NULLIF(w.total_segment_decisioned,0)
            )
        ),
        2
    ) AS standardized_denial_rate,

    COUNT(*) AS standardized_segments

FROM common_segments c

INNER JOIN segment_weights w
    ON c.loan_purpose_label = w.loan_purpose_label
   AND c.loan_type = w.loan_type

GROUP BY c.race_group

ORDER BY standardized_denial_rate DESC;

USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
                THEN 'Asian'
            WHEN applicant_race_1 = 5
                THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN
        (2,21,22,23,24,25,26,27,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
)

SELECT
    r.loan_purpose_label,

    CASE r.loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,

    MAX(CASE WHEN r.race_group = 'Asian'
        THEN r.decisioned_applications END) AS asian_decisioned,

    MAX(CASE WHEN r.race_group = 'White'
        THEN r.decisioned_applications END) AS white_decisioned,

    ROUND(
        MAX(CASE WHEN r.race_group = 'Asian'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS asian_denial_rate,

    ROUND(
        MAX(CASE WHEN r.race_group = 'White'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS white_denial_rate,

    ROUND(
        MAX(CASE WHEN r.race_group = 'Asian'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END)
        -
        MAX(CASE WHEN r.race_group = 'White'
            THEN r.applications_denied * 100.0 /
                 NULLIF(r.decisioned_applications,0) END),
        2
    ) AS asian_minus_white_gap_pp

FROM race_segment r

INNER JOIN eligible_segments e
    ON r.loan_purpose_label = e.loan_purpose_label
   AND r.loan_type = e.loan_type

GROUP BY
    r.loan_purpose_label,
    r.loan_type

ORDER BY
    asian_minus_white_gap_pp DESC;
    
USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 1 THEN 'AIAN'
            WHEN applicant_race_1 = 5 THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
            AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN (1,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT r.*
    FROM race_segment r
    INNER JOIN eligible_segments e
        ON r.loan_purpose_label = e.loan_purpose_label
       AND r.loan_type = e.loan_type
),

segment_weights AS (
    SELECT
        loan_purpose_label,
        loan_type,
        SUM(decisioned_applications) AS segment_decisioned,
        SUM(SUM(decisioned_applications)) OVER ()
            AS total_segment_decisioned
    FROM common_segments
    GROUP BY
        loan_purpose_label,
        loan_type
)

SELECT
    c.race_group,

    ROUND(
        SUM(
            (
                c.applications_denied * 100.0 /
                NULLIF(c.decisioned_applications,0)
            )
            *
            (
                w.segment_decisioned * 1.0 /
                NULLIF(w.total_segment_decisioned,0)
            )
        ),
        2
    ) AS standardized_denial_rate,

    COUNT(*) AS standardized_segments

FROM common_segments c

INNER JOIN segment_weights w
    ON c.loan_purpose_label = w.loan_purpose_label
   AND c.loan_type = w.loan_type

GROUP BY c.race_group

ORDER BY standardized_denial_rate DESC;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 = 1 THEN 'AIAN'
            WHEN applicant_race_1 = 5 THEN 'White'
        END AS race_group,
        loan_purpose_label,
        loan_type,
        SUM(decisioned) AS decisioned_applications,
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied
    FROM hmda_analytical_prod
    WHERE applicant_race_1 IN (1,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)
    GROUP BY race_group, loan_purpose_label, loan_type
),
eligible_segments AS (
    SELECT loan_purpose_label, loan_type
    FROM race_segment
    GROUP BY loan_purpose_label, loan_type
    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
)
SELECT
    r.loan_purpose_label,
    CASE r.loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA'
    END AS loan_type_label,

    MAX(CASE WHEN race_group = 'AIAN'
        THEN decisioned_applications END) AS AIAN_decisioned,

    MAX(CASE WHEN race_group = 'White'
        THEN decisioned_applications END) AS white_decisioned,

    ROUND(MAX(CASE WHEN race_group = 'AIAN'
        THEN applications_denied * 100.0 /
             NULLIF(decisioned_applications,0) END), 2) AS AIAN_denial_rate,

    ROUND(MAX(CASE WHEN race_group = 'White'
        THEN applications_denied * 100.0 /
             NULLIF(decisioned_applications,0) END), 2) AS white_denial_rate,

    ROUND(
        MAX(CASE WHEN race_group = 'AIAN'
            THEN applications_denied * 100.0 /
                 NULLIF(decisioned_applications,0) END)
        -
        MAX(CASE WHEN race_group = 'White'
            THEN applications_denied * 100.0 /
                 NULLIF(decisioned_applications,0) END),
        2
    ) AS AIAN_minus_white_gap_pp

FROM race_segment r
INNER JOIN eligible_segments e
    ON r.loan_purpose_label = e.loan_purpose_label
   AND r.loan_type = e.loan_type
GROUP BY r.loan_purpose_label, r.loan_type
ORDER BY AIAN_minus_white_gap_pp DESC;

USE hmda_credit_risk;

WITH race_segment AS (
    SELECT
        CASE
            WHEN applicant_race_1 IN (4,41,42,43,44) THEN 'NHPI'
            WHEN applicant_race_1 = 5 THEN 'White'
        END AS race_group,

        loan_purpose_label,
        loan_type,

        SUM(decisioned) AS decisioned_applications,

        SUM(CASE
            WHEN action_taken = 3 THEN 1
            ELSE 0
        END) AS applications_denied

    FROM hmda_analytical_prod

    WHERE applicant_race_1 IN (4,41,42,43,44,5)
      AND loan_purpose_label IS NOT NULL
      AND loan_type IN (1,2,3,4)

    GROUP BY
        race_group,
        loan_purpose_label,
        loan_type
),

eligible_segments AS (
    SELECT
        loan_purpose_label,
        loan_type

    FROM race_segment

    GROUP BY
        loan_purpose_label,
        loan_type

    HAVING COUNT(DISTINCT race_group) = 2
       AND MIN(decisioned_applications) >= 10000
),

common_segments AS (
    SELECT r.*
    FROM race_segment r
    INNER JOIN eligible_segments e
        ON r.loan_purpose_label = e.loan_purpose_label
       AND r.loan_type = e.loan_type
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
    c.race_group,

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
    c.race_group

ORDER BY
    standardized_denial_rate DESC;