USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_credit_risk_kpis AS
SELECT
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
        END) / SUM(decisioned) * 100,
        2
    ) AS decisioned_denial_rate

FROM hmda_analytical_prod;

SELECT *
FROM vw_credit_risk_kpis;