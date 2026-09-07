USE hmda_credit_risk;

-- Interest rate analysis for originated loans

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS originated_loans,

    ROUND(AVG(interest_rate), 3) AS avg_interest_rate,

    ROUND(MIN(interest_rate), 3) AS min_interest_rate,

    ROUND(MAX(interest_rate), 3) AS max_interest_rate,

    ROUND(
        STDDEV(interest_rate),
        3
    ) AS interest_rate_stddev

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND interest_rate IS NOT NULL

GROUP BY loan_type

ORDER BY avg_interest_rate DESC;


-- Interest-rate data quality check

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS originated_loans,

    SUM(
        CASE
            WHEN interest_rate = 0 THEN 1
            ELSE 0
        END
    ) AS zero_rate_loans,

    ROUND(
        SUM(
            CASE
                WHEN interest_rate = 0 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS zero_rate_pct

FROM hmda_analytical_prod

WHERE action_taken = 1

GROUP BY loan_type

ORDER BY zero_rate_pct DESC;


-- Interest-rate robustness check
-- Compare averages including and excluding zero rates

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS originated_loans,

    ROUND(
        AVG(interest_rate),
        3
    ) AS avg_rate_including_zero,

    ROUND(
        AVG(
            CASE
                WHEN interest_rate > 0 THEN interest_rate
            END
        ),
        3
    ) AS avg_rate_excluding_zero,

    ROUND(
        AVG(
            CASE
                WHEN interest_rate > 0 THEN interest_rate
            END
        ) - AVG(interest_rate),
        3
    ) AS average_rate_difference

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND interest_rate IS NOT NULL

GROUP BY loan_type

ORDER BY average_rate_difference DESC;


-- Interest rate by loan type within loan purpose

SELECT
    loan_purpose_label,

    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS originated_loans,

    ROUND(
        AVG(interest_rate),
        3
    ) AS avg_interest_rate,

    ROUND(
        STDDEV(interest_rate),
        3
    ) AS interest_rate_stddev

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND interest_rate IS NOT NULL

GROUP BY
    loan_purpose_label,
    loan_type

HAVING
    COUNT(*) >= 10000

ORDER BY
    loan_purpose_label,
    avg_interest_rate DESC;
    
    
-- Rate spread by loan type
-- Rate spread provides a benchmark-relative pricing view

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS loans_with_rate_spread,

    ROUND(
        AVG(rate_spread),
        3
    ) AS avg_rate_spread,

    ROUND(
        MIN(rate_spread),
        3
    ) AS min_rate_spread,

    ROUND(
        MAX(rate_spread),
        3
    ) AS max_rate_spread

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND rate_spread IS NOT NULL

GROUP BY loan_type

ORDER BY avg_rate_spread DESC;


-- Rate spread data-quality investigation

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS loans_with_rate_spread,

    SUM(
        CASE
            WHEN ABS(rate_spread) > 10 THEN 1
            ELSE 0
        END
    ) AS extreme_spread_records,

    ROUND(
        SUM(
            CASE
                WHEN ABS(rate_spread) > 10 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        3
    ) AS extreme_spread_pct

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND rate_spread IS NOT NULL

GROUP BY loan_type

ORDER BY extreme_spread_pct DESC;


-- Robust rate-spread analysis
-- Excludes only extreme observations beyond +/-10 percentage points

SELECT
    loan_type,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
    END AS loan_type_label,

    COUNT(*) AS loans_with_rate_spread,

    SUM(
        CASE
            WHEN ABS(rate_spread) > 10 THEN 1
            ELSE 0
        END
    ) AS excluded_extreme_records,

    ROUND(
        AVG(
            CASE
                WHEN ABS(rate_spread) <= 10
                THEN rate_spread
            END
        ),
        3
    ) AS robust_avg_rate_spread,

    ROUND(
        MIN(
            CASE
                WHEN ABS(rate_spread) <= 10
                THEN rate_spread
            END
        ),
        3
    ) AS robust_min_rate_spread,

    ROUND(
        MAX(
            CASE
                WHEN ABS(rate_spread) <= 10
                THEN rate_spread
            END
        ),
        3
    ) AS robust_max_rate_spread

FROM hmda_analytical_prod

WHERE action_taken = 1
  AND rate_spread IS NOT NULL

GROUP BY loan_type

ORDER BY robust_avg_rate_spread DESC;