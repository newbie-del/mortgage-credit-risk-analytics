USE hmda_credit_risk;

SHOW FULL TABLES;

SHOW CREATE VIEW vw_credit_risk_kpis;

DESCRIBE hmda_analytical_prod;

SELECT VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'hmda_credit_risk'
  AND TABLE_NAME = 'vw_credit_risk_kpis';
  
DESCRIBE hmda_analytical_prod;


DESCRIBE hmda_analytical_prod;

USE hmda_credit_risk;

DESCRIBE hmda_analytical_prod;

SELECT VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'hmda_credit_risk'
  AND TABLE_NAME = 'vw_credit_risk_kpis';
  
SHOW CREATE VIEW vw_credit_risk_kpis;

SHOW COLUMNS FROM hmda_analytical_prod;

SELECT * 
FROM vw_credit_risk_kpis;

USE hmda_credit_risk;

-- ============================================================
-- POWER BI ANALYTICAL LAYER
-- Source: hmda_analytical_prod
-- Purpose: reusable aggregated views for Power BI
-- ============================================================


-- ============================================================
-- 1. Executive KPI View
-- Existing view retained; recreate consistently.
-- ============================================================

CREATE OR REPLACE VIEW vw_credit_risk_kpis AS
SELECT
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS decisioned_denial_rate
FROM hmda_analytical_prod;


-- ============================================================
-- 2. Loan Purpose Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_loan_purpose_risk AS
SELECT
    loan_purpose_label,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_purpose_label;


-- ============================================================
-- 3. DTI Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_dti_risk AS
SELECT
    TRIM(REPLACE(dti_bucket, CHAR(13), '')) AS dti_bucket,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY TRIM(REPLACE(dti_bucket, CHAR(13), ''));


-- ============================================================
-- 4. LTV Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_ltv_risk AS
SELECT
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')) AS ltv_bucket,
    ltv_quality_flag,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')),
    ltv_quality_flag;


-- ============================================================
-- 5. Geographic Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_geographic_risk AS
SELECT
    state_code,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY state_code;


-- ============================================================
-- 6. Loan Type Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_loan_type_risk AS
SELECT
    loan_type,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_type;


-- ============================================================
-- 7. Occupancy Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_occupancy_risk AS
SELECT
    occupancy_type,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY occupancy_type;


-- ============================================================
-- 8. Lien Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_lien_risk AS
SELECT
    lien_status,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY lien_status;


-- ============================================================
-- 9. Demographic Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_demographic_risk AS

SELECT
    'Sex' AS demographic_type,
    CAST(applicant_sex AS CHAR) AS demographic_category,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY applicant_sex

UNION ALL

SELECT
    'Race' AS demographic_type,
    CAST(applicant_race_1 AS CHAR) AS demographic_category,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY applicant_race_1

UNION ALL

SELECT
    'Ethnicity' AS demographic_type,
    CAST(applicant_ethnicity_1 AS CHAR) AS demographic_category,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY applicant_ethnicity_1;


-- ============================================================
-- 10. Risk Concentration
-- ============================================================

CREATE OR REPLACE VIEW vw_risk_concentration AS

SELECT
    'Loan Purpose' AS dimension_type,
    loan_purpose_label AS dimension_value,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(decisioned) /
        NULLIF(
            (SELECT SUM(decisioned)
             FROM hmda_analytical_prod), 0
        ) * 100,
        2
    ) AS decisioned_volume_share_pct,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_purpose_label

UNION ALL

SELECT
    'DTI' AS dimension_type,
    TRIM(REPLACE(dti_bucket, CHAR(13), '')) AS dimension_value,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(decisioned) /
        NULLIF(
            (SELECT SUM(decisioned)
             FROM hmda_analytical_prod), 0
        ) * 100,
        2
    ) AS decisioned_volume_share_pct,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY TRIM(REPLACE(dti_bucket, CHAR(13), ''));

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'hmda_credit_risk'
ORDER BY TABLE_NAME;

SELECT *
FROM vw_risk_concentration
ORDER BY dimension_type, decisioned_volume_share_pct DESC;

USE hmda_credit_risk;

-- ============================================================
-- 1. Loan Purpose Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_loan_purpose_risk AS
SELECT
    loan_purpose_label,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_purpose_label;


-- ============================================================
-- 2. DTI Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_dti_risk AS
SELECT
    TRIM(REPLACE(dti_bucket, CHAR(13), '')) AS dti_bucket,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY TRIM(REPLACE(dti_bucket, CHAR(13), ''));


-- ============================================================
-- 3. LTV Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_ltv_risk AS
SELECT
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')) AS ltv_bucket,
    ltv_quality_flag,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')),
    ltv_quality_flag;


-- ============================================================
-- 4. Geographic Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_geographic_risk AS
SELECT
    state_code,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY state_code;USE hmda_credit_risk;

-- ============================================================
-- 1. Loan Purpose Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_loan_purpose_risk AS
SELECT
    loan_purpose_label,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_purpose_label;


-- ============================================================
-- 2. DTI Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_dti_risk AS
SELECT
    TRIM(REPLACE(dti_bucket, CHAR(13), '')) AS dti_bucket,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY TRIM(REPLACE(dti_bucket, CHAR(13), ''));


-- ============================================================
-- 3. LTV Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_ltv_risk AS
SELECT
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')) AS ltv_bucket,
    ltv_quality_flag,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY
    TRIM(REPLACE(ltv_bucket, CHAR(13), '')),
    ltv_quality_flag;


-- ============================================================
-- 4. Geographic Risk
-- ============================================================

CREATE OR REPLACE VIEW vw_geographic_risk AS
SELECT
    state_code,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY state_code;


SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'hmda_credit_risk'
ORDER BY TABLE_NAME;

USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_loan_type_risk AS
SELECT
    loan_type,
    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 1) AS loans_originated,
    SUM(action_taken = 3) AS applications_denied,
    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
GROUP BY loan_type;


CREATE OR REPLACE VIEW vw_occupancy_risk AS

SELECT
    occupancy_type,

    CASE occupancy_type
        WHEN 1 THEN 'Principal Residence'
        WHEN 2 THEN 'Second Residence'
        WHEN 3 THEN 'Investment Property'
        ELSE 'Not Available'
    END AS occupancy_type_label,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    SUM(action_taken = 1) AS loans_originated,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod
GROUP BY occupancy_type;


SELECT
    occupancy_type_label,
    decisioned_applications,
    applications_denied,
    denial_rate
FROM vw_occupancy_risk
ORDER BY denial_rate DESC;

use hmda_credit_risk;




CREATE OR REPLACE VIEW vw_lien_risk AS

SELECT
    lien_status,

    CASE lien_status
        WHEN 1 THEN 'First Lien'
        WHEN 2 THEN 'Subordinate Lien'
        ELSE 'Not Available'
    END AS lien_status_label,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    SUM(action_taken = 1) AS loans_originated,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY lien_status;

SELECT
    lien_status_label,
    decisioned_applications,
    applications_denied,
    denial_rate
FROM vw_lien_risk
ORDER BY denial_rate DESC;


CREATE OR REPLACE VIEW vw_demographic_risk AS

/* =========================
   SEX
   ========================= */

SELECT
    'Sex' AS demographic_type,

    CASE
        WHEN applicant_sex = 1 THEN 'Male'
        WHEN applicant_sex = 2 THEN 'Female'
        WHEN applicant_sex = 3 THEN 'Information Not Provided'
        WHEN applicant_sex = 4 THEN 'Not Applicable'
        WHEN applicant_sex = 6 THEN 'Male and Female'
        ELSE 'Missing'
    END AS demographic_category,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod
GROUP BY
    CASE
        WHEN applicant_sex = 1 THEN 'Male'
        WHEN applicant_sex = 2 THEN 'Female'
        WHEN applicant_sex = 3 THEN 'Information Not Provided'
        WHEN applicant_sex = 4 THEN 'Not Applicable'
        WHEN applicant_sex = 6 THEN 'Male and Female'
        ELSE 'Missing'
    END


UNION ALL


/* =========================
   RACE — FIRST-REPORTED
   ========================= */

SELECT
    'Race' AS demographic_type,

    CASE
        WHEN applicant_race_1 = 1 THEN 'AIAN'
        WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
            THEN 'Asian'
        WHEN applicant_race_1 = 3
            THEN 'Black / African American'
        WHEN applicant_race_1 IN (4,41,42,43,44)
            THEN 'NHPI'
        WHEN applicant_race_1 = 5
            THEN 'White'
        WHEN applicant_race_1 = 6
            THEN 'Information Not Provided'
        WHEN applicant_race_1 = 7
            THEN 'Not Applicable'
        ELSE 'Missing'
    END AS demographic_category,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod
GROUP BY
    CASE
        WHEN applicant_race_1 = 1 THEN 'AIAN'
        WHEN applicant_race_1 IN (2,21,22,23,24,25,26,27)
            THEN 'Asian'
        WHEN applicant_race_1 = 3
            THEN 'Black / African American'
        WHEN applicant_race_1 IN (4,41,42,43,44)
            THEN 'NHPI'
        WHEN applicant_race_1 = 5
            THEN 'White'
        WHEN applicant_race_1 = 6
            THEN 'Information Not Provided'
        WHEN applicant_race_1 = 7
            THEN 'Not Applicable'
        ELSE 'Missing'
    END


UNION ALL


/* =========================
   ETHNICITY — FIRST-REPORTED
   ========================= */

SELECT
    'Ethnicity' AS demographic_type,

    CASE
        WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
            THEN 'Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'
        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'
        ELSE 'Missing'
    END AS demographic_category,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod
GROUP BY
    CASE
        WHEN applicant_ethnicity_1 IN (1,11,12,13,14)
            THEN 'Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 2
            THEN 'Not Hispanic / Latino'
        WHEN applicant_ethnicity_1 = 3
            THEN 'Information Not Provided'
        WHEN applicant_ethnicity_1 = 4
            THEN 'Not Applicable'
        ELSE 'Missing'
    END
    
    UNION ALL

/* =========================
   AGE
   ========================= */

SELECT
    'Age' AS demographic_type,

    CASE
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '<25'
            THEN '<25'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '25-34'
            THEN '25-34'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '35-44'
            THEN '35-44'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '45-54'
            THEN '45-54'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '55-64'
            THEN '55-64'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '65-74'
            THEN '65-74'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '>74'
            THEN '>74'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '8888'
            THEN 'Not Applicable'
        ELSE 'Missing'
    END AS demographic_category,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY
    CASE
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '<25'
            THEN '<25'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '25-34'
            THEN '25-34'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '35-44'
            THEN '35-44'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '45-54'
            THEN '45-54'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '55-64'
            THEN '55-64'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '65-74'
            THEN '65-74'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '>74'
            THEN '>74'
        WHEN TRIM(CAST(applicant_age AS CHAR)) = '8888'
            THEN 'Not Applicable'
        ELSE 'Missing'
    END;
    
SELECT
    demographic_category,
    decisioned_applications,
    applications_denied,
    denial_rate
FROM vw_demographic_risk
WHERE demographic_type = 'Age'
ORDER BY denial_rate DESC;
    
    
SELECT
    demographic_type,
    demographic_category,
    decisioned_applications,
    applications_denied,
    denial_rate
FROM vw_demographic_risk
ORDER BY
    demographic_type,
    denial_rate DESC;
    
    
    
    
USE hmda_credit_risk;

SELECT * FROM vw_credit_risk_kpis;

SELECT * 
FROM vw_loan_purpose_risk
ORDER BY denial_rate DESC;

SELECT * 
FROM vw_dti_risk
ORDER BY denial_rate DESC;

SELECT * 
FROM vw_ltv_risk
ORDER BY denial_rate DESC;


USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_demographic_standardized AS

SELECT
    'Race' AS demographic_type,
    'Black vs White' AS comparison,
    'Black / African American' AS demographic_group,
    39.47 AS standardized_denial_rate,
    22.65 AS reference_denial_rate,
    16.82 AS gap_pp,
    11 AS common_segments

UNION ALL

SELECT
    'Race',
    'Black vs White',
    'White',
    22.65,
    22.65,
    16.82,
    11

UNION ALL

SELECT
    'Race',
    'Asian vs White',
    'Asian',
    25.62,
    21.99,
    3.63,
    7

UNION ALL

SELECT
    'Race',
    'Asian vs White',
    'White',
    21.99,
    21.99,
    3.63,
    7

UNION ALL

SELECT
    'Race',
    'AIAN vs White',
    'AIAN',
    39.12,
    22.57,
    16.55,
    4

UNION ALL

SELECT
    'Race',
    'AIAN vs White',
    'White',
    22.57,
    22.57,
    16.55,
    4

UNION ALL

SELECT
    'Ethnicity',
    'Hispanic vs Not Hispanic',
    'Hispanic / Latino',
    24.97,
    17.93,
    7.04,
    10

UNION ALL

SELECT
    'Ethnicity',
    'Hispanic vs Not Hispanic',
    'Not Hispanic / Latino',
    17.93,
    17.93,
    7.04,
    10

UNION ALL

SELECT
    'Sex',
    'Female vs Male',
    'Female',
    26.96,
    23.90,
    3.06,
    12

UNION ALL

SELECT
    'Sex',
    'Female vs Male',
    'Male',
    23.90,
    23.90,
    3.06,
    12;
    
SELECT *
FROM vw_demographic_standardized;


USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_loan_purpose_type_risk AS

SELECT
    CASE loan_purpose
        WHEN 1 THEN 'Home Purchase'
        WHEN 2 THEN 'Home Improvement'
        WHEN 31 THEN 'Refinancing'
        WHEN 32 THEN 'Cash-out Refinancing'
        WHEN 4 THEN 'Other Purpose'
        WHEN 5 THEN 'Not Applicable'
        ELSE 'Unknown'
    END AS loan_purpose_label,

    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
        ELSE 'Unknown'
    END AS loan_type_label,

    COUNT(*) AS total_applications,
    SUM(decisioned) AS decisioned_applications,
    SUM(action_taken = 3) AS applications_denied,
    SUM(action_taken = 1) AS loans_originated,

    ROUND(
        SUM(action_taken = 3) /
        NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate

FROM hmda_analytical_prod

GROUP BY
    loan_purpose,
    loan_type;
    
    
SELECT
    loan_purpose_label,
    loan_type_label,
    decisioned_applications,
    applications_denied,
    denial_rate
FROM vw_loan_purpose_type_risk
WHERE decisioned_applications >= 10000
ORDER BY denial_rate DESC;


USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_pricing_risk AS

SELECT
    CASE loan_type
        WHEN 1 THEN 'Conventional'
        WHEN 2 THEN 'FHA'
        WHEN 3 THEN 'VA'
        WHEN 4 THEN 'USDA / RHS'
        ELSE 'Unknown'
    END AS loan_type_label,

    COUNT(*) AS originated_loans,

    ROUND(
        AVG(NULLIF(interest_rate, 0)),
        3
    ) AS avg_interest_rate,

    ROUND(
        AVG(
            CASE
                WHEN ABS(rate_spread) <= 10
                THEN rate_spread
            END
        ),
        3
    ) AS avg_rate_spread,

    SUM(
        CASE
            WHEN interest_rate = 0 THEN 1
            ELSE 0
        END
    ) AS zero_rate_loans

FROM hmda_analytical_prod

WHERE action_taken = 1

GROUP BY loan_type;

SELECT
    loan_type_label,
    originated_loans,
    avg_interest_rate,
    avg_rate_spread,
    zero_rate_loans
FROM vw_pricing_risk
ORDER BY avg_interest_rate DESC;

USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_denial_reason_by_purpose AS

SELECT
    CASE loan_purpose
        WHEN 1 THEN 'Home Purchase'
        WHEN 2 THEN 'Home Improvement'
        WHEN 31 THEN 'Refinancing'
        WHEN 32 THEN 'Cash-out Refinancing'
        WHEN 4 THEN 'Other Purpose'
        WHEN 5 THEN 'Not Applicable'
    END AS loan_purpose_label,

    denial_reason,

    COUNT(*) AS reason_occurrences

FROM (

    SELECT
        loan_purpose,
        CASE denial_reason_1
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
        END AS denial_reason
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_1 IS NOT NULL

    UNION ALL

    SELECT
        loan_purpose,
        CASE denial_reason_2
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
        END
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_2 IS NOT NULL

    UNION ALL

    SELECT
        loan_purpose,
        CASE denial_reason_3
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
        END
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_3 IS NOT NULL

    UNION ALL

    SELECT
        loan_purpose,
        CASE denial_reason_4
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
        END
    FROM hmda_analytical_prod
    WHERE action_taken = 3
      AND denial_reason_4 IS NOT NULL

) AS reasons

WHERE denial_reason IS NOT NULL

GROUP BY
    loan_purpose,
    denial_reason

ORDER BY
    loan_purpose_label,
    reason_occurrences DESC;
    
SELECT *
FROM vw_denial_reason_by_purpose
ORDER BY loan_purpose_label, reason_occurrences DESC;


USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_dti_purpose_risk AS
SELECT
    REPLACE(TRIM(dti_bucket), CHAR(13), '') AS dti_bucket,
    loan_purpose_label,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
WHERE decisioned = 1
  AND dti_bucket IS NOT NULL
  AND TRIM(dti_bucket) <> ''
  AND REPLACE(TRIM(dti_bucket), CHAR(13), '') NOT IN ('Missing', 'Exempt')
GROUP BY
    REPLACE(TRIM(dti_bucket), CHAR(13), ''),
    loan_purpose_label;
    
SELECT *
FROM vw_dti_purpose_risk
ORDER BY denial_rate DESC;


USE hmda_credit_risk;

CREATE OR REPLACE VIEW vw_occupancy_purpose_risk AS
SELECT
    loan_purpose_label,
    occupancy_type_label,
    SUM(decisioned) AS decisioned_applications,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS applications_denied,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / NULLIF(SUM(decisioned), 0) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
WHERE decisioned = 1
GROUP BY
    loan_purpose_label,
    occupancy_type_label;