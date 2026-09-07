USE hmda_credit_risk;

SELECT
    r.denial_reason,
    m.denial_reason_label,
    COUNT(*) AS reason_occurrences

FROM (
    SELECT denial_reason_1 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT denial_reason_2 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT denial_reason_3 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT denial_reason_4 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3
) r

LEFT JOIN (
    SELECT 1 AS denial_reason, 'Debt-to-income ratio' AS denial_reason_label
    UNION ALL SELECT 2, 'Employment history'
    UNION ALL SELECT 3, 'Credit history'
    UNION ALL SELECT 4, 'Collateral'
    UNION ALL SELECT 5, 'Insufficient cash'
    UNION ALL SELECT 6, 'Unverifiable information'
    UNION ALL SELECT 7, 'Credit application incomplete'
    UNION ALL SELECT 8, 'Mortgage insurance denied'
    UNION ALL SELECT 9, 'Other'
    UNION ALL SELECT 10, 'Not applicable'
    UNION ALL SELECT 1111, 'Exempt'
) m
    ON r.denial_reason = m.denial_reason

WHERE r.denial_reason IS NOT NULL

GROUP BY
    r.denial_reason,
    m.denial_reason_label

ORDER BY reason_occurrences DESC;


-- Denial reasons by loan purpose

WITH denial_reasons AS (
    SELECT
        loan_purpose_label,
        denial_reason_1 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT
        loan_purpose_label,
        denial_reason_2 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT
        loan_purpose_label,
        denial_reason_3 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT
        loan_purpose_label,
        denial_reason_4 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3
)

SELECT
    loan_purpose_label,
    denial_reason,
    CASE denial_reason
        WHEN 1 THEN 'Debt-to-income ratio'
        WHEN 2 THEN 'Employment history'
        WHEN 3 THEN 'Credit history'
        WHEN 4 THEN 'Collateral'
        WHEN 5 THEN 'Insufficient cash'
        WHEN 6 THEN 'Unverifiable information'
        WHEN 7 THEN 'Credit application incomplete'
        WHEN 8 THEN 'Mortgage insurance denied'
        WHEN 9 THEN 'Other'
        WHEN 10 THEN 'Not applicable'
        WHEN 1111 THEN 'Exempt'
    END AS denial_reason_label,
    COUNT(*) AS reason_occurrences
FROM denial_reasons
WHERE denial_reason IS NOT NULL
GROUP BY
    loan_purpose_label,
    denial_reason,
    denial_reason_label
ORDER BY
    loan_purpose_label,
    reason_occurrences DESC;
    

-- Denial reason mix by loan purpose

WITH denial_reasons AS (
    SELECT loan_purpose_label, denial_reason_1 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT loan_purpose_label, denial_reason_2
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT loan_purpose_label, denial_reason_3
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL

    SELECT loan_purpose_label, denial_reason_4
    FROM hmda_analytical_prod
    WHERE action_taken = 3
),

reason_counts AS (
    SELECT
        loan_purpose_label,
        denial_reason,
        COUNT(*) AS reason_occurrences
    FROM denial_reasons
    WHERE denial_reason IS NOT NULL
    GROUP BY
        loan_purpose_label,
        denial_reason
)

SELECT
    loan_purpose_label,
    denial_reason,
    CASE denial_reason
        WHEN 1 THEN 'Debt-to-income ratio'
        WHEN 2 THEN 'Employment history'
        WHEN 3 THEN 'Credit history'
        WHEN 4 THEN 'Collateral'
        WHEN 5 THEN 'Insufficient cash'
        WHEN 6 THEN 'Unverifiable information'
        WHEN 7 THEN 'Credit application incomplete'
        WHEN 8 THEN 'Mortgage insurance denied'
        WHEN 9 THEN 'Other'
        WHEN 10 THEN 'Not applicable'
        WHEN 1111 THEN 'Exempt'
    END AS denial_reason_label,
    reason_occurrences,
    ROUND(
        reason_occurrences /
        SUM(reason_occurrences) OVER (
            PARTITION BY loan_purpose_label
        ) * 100,
        2
    ) AS reason_share_pct
FROM reason_counts
ORDER BY
    loan_purpose_label,
    reason_share_pct DESC;
    
    
-- Validate that reason shares sum to approximately 100% per loan purpose

WITH denial_reasons AS (
    SELECT loan_purpose_label, denial_reason_1 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_2
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_3
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_4
    FROM hmda_analytical_prod
    WHERE action_taken = 3
),

reason_counts AS (
    SELECT
        loan_purpose_label,
        denial_reason,
        COUNT(*) AS reason_occurrences
    FROM denial_reasons
    WHERE denial_reason IS NOT NULL
    GROUP BY loan_purpose_label, denial_reason
)

SELECT
    loan_purpose_label,
    SUM(reason_occurrences) AS total_reason_occurrences,
    ROUND(
        SUM(reason_occurrences) * 100.0 /
        SUM(SUM(reason_occurrences)) OVER (),
        2
    ) AS overall_reason_share_pct
FROM reason_counts
GROUP BY loan_purpose_label
ORDER BY total_reason_occurrences DESC;


-- Validate within-purpose denial reason shares

WITH denial_reasons AS (
    SELECT loan_purpose_label, denial_reason_1 AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_2
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_3
    FROM hmda_analytical_prod
    WHERE action_taken = 3

    UNION ALL
    SELECT loan_purpose_label, denial_reason_4
    FROM hmda_analytical_prod
    WHERE action_taken = 3
),

reason_counts AS (
    SELECT
        loan_purpose_label,
        denial_reason,
        COUNT(*) AS reason_occurrences
    FROM denial_reasons
    WHERE denial_reason IS NOT NULL
    GROUP BY loan_purpose_label, denial_reason
),

reason_shares AS (
    SELECT
        loan_purpose_label,
        denial_reason,
        reason_occurrences,
        ROUND(
            reason_occurrences * 100.0 /
            SUM(reason_occurrences) OVER (
                PARTITION BY loan_purpose_label
            ),
            2
        ) AS reason_share_pct
    FROM reason_counts
)

SELECT
    loan_purpose_label,
    ROUND(SUM(reason_share_pct), 2) AS total_reason_share_pct
FROM reason_shares
GROUP BY loan_purpose_label
ORDER BY loan_purpose_label;




