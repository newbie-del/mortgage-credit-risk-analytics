USE hmda_credit_risk;

-- Occupancy type credit risk analysis

SELECT
    occupancy_type,

    CASE occupancy_type
        WHEN 1 THEN 'Principal Residence'
        WHEN 2 THEN 'Second Residence'
        WHEN 3 THEN 'Investment Property'
    END AS occupancy_type_label,

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

WHERE occupancy_type IN (1, 2, 3)

GROUP BY
    occupancy_type

ORDER BY
    decisioned_denial_rate DESC;
    
    
-- Occupancy × loan purpose risk analysis

SELECT
    loan_purpose_label,

    occupancy_type,

    CASE occupancy_type
        WHEN 1 THEN 'Principal Residence'
        WHEN 2 THEN 'Second Residence'
        WHEN 3 THEN 'Investment Property'
    END AS occupancy_type_label,

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

WHERE occupancy_type IN (1, 2, 3)

GROUP BY
    loan_purpose_label,
    occupancy_type

HAVING
    SUM(decisioned) >= 10000

ORDER BY
    loan_purpose_label,
    decisioned_denial_rate DESC;