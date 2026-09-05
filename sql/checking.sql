CREATE DATABASE hmda_credit_risk;
USE hmda_credit_risk;
SELECT DATABASE();

CREATE TABLE hmda_analytical (
    activity_year INT,
    lei VARCHAR(25),
    state_code VARCHAR(2),
    county_code INT,
    derived_msa_md INT,
    derived_dwelling_category VARCHAR(100),

    action_taken INT,
    action_taken_label VARCHAR(50),

    loan_type INT,
    loan_purpose INT,
    loan_purpose_label VARCHAR(50),

    lien_status INT,
    occupancy_type INT,

    loan_amount DECIMAL(15,2),
    property_value DECIMAL(15,2),
    interest_rate DECIMAL(10,4),
    rate_spread DECIMAL(10,4),

    debt_to_income_ratio VARCHAR(20),
    dti_bucket VARCHAR(20),

    ltv DECIMAL(12,4),
    ltv_bucket VARCHAR(20),

    decisioned BOOLEAN,

    applicant_credit_score_type INT,

    applicant_ethnicity_1 VARCHAR(10),
    applicant_race_1 VARCHAR(10),
    applicant_sex VARCHAR(10),
    applicant_age VARCHAR(20),

    denial_reason_1 INT,
    denial_reason_2 INT,
    denial_reason_3 INT,
    denial_reason_4 INT
);


DESCRIBE hmda_analytical;

SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'secure_file_priv';

SET GLOBAL local_infile = 1;

CREATE TABLE hmda_import_test LIKE hmda_analytical;

SHOW TABLES;

USE hmda_credit_risk;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_mysql_test.csv'
INTO TABLE hmda_import_test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT @@secure_file_priv;

DROP TABLE hmda_import_test;

CREATE TABLE hmda_import_test (
    activity_year VARCHAR(10),
    lei VARCHAR(25),
    derived_msa_md VARCHAR(20),
    state_code VARCHAR(10),
    county_code VARCHAR(20),
    derived_dwelling_category VARCHAR(100),

    action_taken VARCHAR(10),
    action_taken_label VARCHAR(50),

    loan_type VARCHAR(10),
    loan_purpose VARCHAR(10),
    loan_purpose_label VARCHAR(50),

    lien_status VARCHAR(10),
    occupancy_type VARCHAR(10),

    loan_amount VARCHAR(30),
    property_value VARCHAR(30),
    interest_rate VARCHAR(30),
    rate_spread VARCHAR(30),

    debt_to_income_ratio VARCHAR(20),
    dti_bucket VARCHAR(20),

    ltv VARCHAR(30),
    ltv_bucket VARCHAR(20),

    decisioned VARCHAR(10),

    applicant_credit_score_type VARCHAR(10),

    applicant_ethnicity_1 VARCHAR(10),
    applicant_race_1 VARCHAR(10),
    applicant_sex VARCHAR(10),
    applicant_age VARCHAR(20),

    denial_reason_1 VARCHAR(10),
    denial_reason_2 VARCHAR(10),
    denial_reason_3 VARCHAR(10),
    denial_reason_4 VARCHAR(10)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_mysql_test.csv'
INTO TABLE hmda_import_test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


DROP TABLE hmda_import_test;

CREATE TABLE hmda_import_test (
    activity_year VARCHAR(10),
    lei VARCHAR(25),
    derived_msa_md VARCHAR(20),
    state_code VARCHAR(10),
    county_code VARCHAR(20),
    derived_dwelling_category VARCHAR(100),

    action_taken VARCHAR(10),
    loan_type VARCHAR(10),
    loan_purpose VARCHAR(10),
    lien_status VARCHAR(10),
    loan_amount VARCHAR(30),
    interest_rate VARCHAR(30),
    rate_spread VARCHAR(30),
    property_value VARCHAR(30),
    occupancy_type VARCHAR(10),
    debt_to_income_ratio VARCHAR(20),
    applicant_credit_score_type VARCHAR(10),
    applicant_ethnicity_1 VARCHAR(10),
    applicant_race_1 VARCHAR(10),
    applicant_sex VARCHAR(10),
    applicant_age VARCHAR(20),

    denial_reason_1 VARCHAR(10),
    denial_reason_2 VARCHAR(10),
    denial_reason_3 VARCHAR(10),
    denial_reason_4 VARCHAR(10),

    decisioned VARCHAR(10),
    loan_purpose_label VARCHAR(50),
    action_taken_label VARCHAR(50),
    dti_bucket VARCHAR(20),
    ltv VARCHAR(30),
    ltv_bucket VARCHAR(20)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_mysql_test.csv'
INTO TABLE hmda_import_test
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS rows_imported
FROM hmda_import_test;

SELECT *
FROM hmda_import_test
LIMIT 5;


SELECT
    activity_year,
    lei,
    state_code,
    county_code,
    action_taken,
    loan_purpose,
    loan_amount,
    property_value,
    debt_to_income_ratio,
    decisioned,
    loan_purpose_label,
    action_taken_label,
    dti_bucket,
    ltv,
    ltv_bucket
FROM hmda_import_test
LIMIT 5;

SELECT COUNT(*) AS total_rows
FROM hmda_import_test;

SELECT
    COUNT(*) AS total_rows,
    SUM(state_code IS NULL OR state_code = '') AS missing_state,
    SUM(property_value IS NULL OR property_value = '') AS missing_property_value,
    SUM(interest_rate IS NULL OR interest_rate = '') AS missing_interest_rate,
    SUM(ltv IS NULL OR ltv = '') AS missing_ltv
FROM hmda_import_test;

USE hmda_credit_risk;

CREATE TABLE hmda_analytical_prod (
    activity_year INT,
    lei VARCHAR(25),
    derived_msa_md INT,
    state_code VARCHAR(2),
    county_code INT,
    derived_dwelling_category VARCHAR(100),

    action_taken INT,
    loan_type INT,
    loan_purpose INT,
    lien_status INT,
    loan_amount DECIMAL(15,2),
    interest_rate DECIMAL(10,4),
    rate_spread DECIMAL(10,4),
    property_value DECIMAL(15,2),
    occupancy_type INT,
    debt_to_income_ratio VARCHAR(20),
    applicant_credit_score_type INT,

    applicant_ethnicity_1 INT,
    applicant_race_1 INT,
    applicant_sex INT,
    applicant_age VARCHAR(20),

    denial_reason_1 INT,
    denial_reason_2 INT,
    denial_reason_3 INT,
    denial_reason_4 INT,

    decisioned BOOLEAN,
    loan_purpose_label VARCHAR(50),
    action_taken_label VARCHAR(50),
    dti_bucket VARCHAR(20),
    ltv DECIMAL(12,4),
    ltv_bucket VARCHAR(20)
);

DESCRIBE hmda_analytical_prod;


USE hmda_credit_risk;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_analytical_dataset.csv'
INTO TABLE hmda_analytical_prod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

USE hmda_credit_risk;

TRUNCATE TABLE hmda_analytical_prod;

SELECT COUNT(*) AS rows_before_import
FROM hmda_analytical_prod;

USE hmda_credit_risk;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_analytical_dataset.csv'
INTO TABLE hmda_analytical_prod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

(
    @activity_year,
    lei,
    @derived_msa_md,
    state_code,
    @county_code,
    derived_dwelling_category,

    @action_taken,
    @loan_type,
    @loan_purpose,
    @lien_status,
    @loan_amount,
    @interest_rate,
    @rate_spread,
    @property_value,
    @occupancy_type,
    debt_to_income_ratio,
    @applicant_credit_score_type,

    @applicant_ethnicity_1,
    @applicant_race_1,
    @applicant_sex,
    applicant_age,

    @denial_reason_1,
    @denial_reason_2,
    @denial_reason_3,
    @denial_reason_4,

    @decisioned,
    loan_purpose_label,
    action_taken_label,
    dti_bucket,
    @ltv,
    ltv_bucket
)

SET
    activity_year = NULLIF(NULLIF(NULLIF(TRIM(@activity_year), ''), 'NA'), 'Exempt'),
    derived_msa_md = NULLIF(NULLIF(NULLIF(TRIM(@derived_msa_md), ''), 'NA'), 'Exempt'),
    county_code = NULLIF(NULLIF(NULLIF(TRIM(@county_code), ''), 'NA'), 'Exempt'),

    action_taken = NULLIF(NULLIF(NULLIF(TRIM(@action_taken), ''), 'NA'), 'Exempt'),
    loan_type = NULLIF(NULLIF(NULLIF(TRIM(@loan_type), ''), 'NA'), 'Exempt'),
    loan_purpose = NULLIF(NULLIF(NULLIF(TRIM(@loan_purpose), ''), 'NA'), 'Exempt'),
    lien_status = NULLIF(NULLIF(NULLIF(TRIM(@lien_status), ''), 'NA'), 'Exempt'),

    loan_amount = NULLIF(NULLIF(NULLIF(TRIM(@loan_amount), ''), 'NA'), 'Exempt'),
    interest_rate = NULLIF(NULLIF(NULLIF(TRIM(@interest_rate), ''), 'NA'), 'Exempt'),
    rate_spread = NULLIF(NULLIF(NULLIF(TRIM(@rate_spread), ''), 'NA'), 'Exempt'),
    property_value = NULLIF(NULLIF(NULLIF(TRIM(@property_value), ''), 'NA'), 'Exempt'),

    occupancy_type = NULLIF(NULLIF(NULLIF(TRIM(@occupancy_type), ''), 'NA'), 'Exempt'),

    applicant_credit_score_type =
        NULLIF(NULLIF(NULLIF(TRIM(@applicant_credit_score_type), ''), 'NA'), 'Exempt'),

    applicant_ethnicity_1 =
        NULLIF(NULLIF(NULLIF(TRIM(@applicant_ethnicity_1), ''), 'NA'), 'Exempt'),

    applicant_race_1 =
        NULLIF(NULLIF(NULLIF(TRIM(@applicant_race_1), ''), 'NA'), 'Exempt'),

    applicant_sex =
        NULLIF(NULLIF(NULLIF(TRIM(@applicant_sex), ''), 'NA'), 'Exempt'),

    denial_reason_1 =
        NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_1), ''), 'NA'), 'Exempt'),

    denial_reason_2 =
        NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_2), ''), 'NA'), 'Exempt'),

    denial_reason_3 =
        NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_3), ''), 'NA'), 'Exempt'),

    denial_reason_4 =
        NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_4), ''), 'NA'), 'Exempt'),

    decisioned = CASE
        WHEN TRIM(@decisioned) = 'True' THEN 1
        WHEN TRIM(@decisioned) = 'False' THEN 0
        ELSE NULL
    END,

    ltv = NULLIF(NULLIF(NULLIF(TRIM(@ltv), ''), 'NA'), 'Exempt');

TRUNCATE TABLE hmda_analytical_prod;

SELECT COUNT(*) AS rows_before_retry
FROM hmda_analytical_prod;

SELECT VERSION();
SELECT COUNT(*) AS rows_loaded
FROM hmda_credit_risk.hmda_analytical_prod;

SHOW GLOBAL STATUS LIKE 'Threads_connected';
SHOW VARIABLES LIKE 'wait_timeout';
SHOW VARIABLES LIKE 'net_read_timeout';
SHOW VARIABLES LIKE 'net_write_timeout';

SHOW VARIABLES LIKE 'wait_timeout';
SELECT COUNT(*) AS rows_loaded
FROM hmda_credit_risk.hmda_analytical_prod;

USE hmda_credit_risk;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hmda_analytical_dataset.csv'
INTO TABLE hmda_analytical_prod
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

(
    @activity_year,
    lei,
    @derived_msa_md,
    state_code,
    @county_code,
    derived_dwelling_category,
    @action_taken,
    @loan_type,
    @loan_purpose,
    @lien_status,
    @loan_amount,
    @interest_rate,
    @rate_spread,
    @property_value,
    @occupancy_type,
    debt_to_income_ratio,
    @applicant_credit_score_type,
    @applicant_ethnicity_1,
    @applicant_race_1,
    @applicant_sex,
    applicant_age,
    @denial_reason_1,
    @denial_reason_2,
    @denial_reason_3,
    @denial_reason_4,
    @decisioned,
    loan_purpose_label,
    action_taken_label,
    dti_bucket,
    @ltv,
    ltv_bucket
)

SET
    activity_year = NULLIF(NULLIF(NULLIF(TRIM(@activity_year), ''), 'NA'), 'Exempt'),
    derived_msa_md = NULLIF(NULLIF(NULLIF(TRIM(@derived_msa_md), ''), 'NA'), 'Exempt'),
    county_code = NULLIF(NULLIF(NULLIF(TRIM(@county_code), ''), 'NA'), 'Exempt'),
    action_taken = NULLIF(NULLIF(NULLIF(TRIM(@action_taken), ''), 'NA'), 'Exempt'),
    loan_type = NULLIF(NULLIF(NULLIF(TRIM(@loan_type), ''), 'NA'), 'Exempt'),
    loan_purpose = NULLIF(NULLIF(NULLIF(TRIM(@loan_purpose), ''), 'NA'), 'Exempt'),
    lien_status = NULLIF(NULLIF(NULLIF(TRIM(@lien_status), ''), 'NA'), 'Exempt'),
    loan_amount = NULLIF(NULLIF(NULLIF(TRIM(@loan_amount), ''), 'NA'), 'Exempt'),
    interest_rate = NULLIF(NULLIF(NULLIF(TRIM(@interest_rate), ''), 'NA'), 'Exempt'),
    rate_spread = NULLIF(NULLIF(NULLIF(TRIM(@rate_spread), ''), 'NA'), 'Exempt'),
    property_value = NULLIF(NULLIF(NULLIF(TRIM(@property_value), ''), 'NA'), 'Exempt'),
    occupancy_type = NULLIF(NULLIF(NULLIF(TRIM(@occupancy_type), ''), 'NA'), 'Exempt'),
    applicant_credit_score_type = NULLIF(NULLIF(NULLIF(TRIM(@applicant_credit_score_type), ''), 'NA'), 'Exempt'),
    applicant_ethnicity_1 = NULLIF(NULLIF(NULLIF(TRIM(@applicant_ethnicity_1), ''), 'NA'), 'Exempt'),
    applicant_race_1 = NULLIF(NULLIF(NULLIF(TRIM(@applicant_race_1), ''), 'NA'), 'Exempt'),
    applicant_sex = NULLIF(NULLIF(NULLIF(TRIM(@applicant_sex), ''), 'NA'), 'Exempt'),
    denial_reason_1 = NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_1), ''), 'NA'), 'Exempt'),
    denial_reason_2 = NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_2), ''), 'NA'), 'Exempt'),
    denial_reason_3 = NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_3), ''), 'NA'), 'Exempt'),
    denial_reason_4 = NULLIF(NULLIF(NULLIF(TRIM(@denial_reason_4), ''), 'NA'), 'Exempt'),
    decisioned = CASE
        WHEN TRIM(@decisioned) = 'True' THEN 1
        WHEN TRIM(@decisioned) = 'False' THEN 0
        ELSE NULL
    END,
    ltv = NULLIF(NULLIF(NULLIF(TRIM(@ltv), ''), 'NA'), 'Exempt');
    
    USE hmda_credit_risk;

SELECT COUNT(*) AS total_rows
FROM hmda_analytical_prod;

SHOW WARNINGS LIMIT 20;

SELECT
    COUNT(*) AS total_ltv,
    COUNT(ltv) AS non_null_ltv,
    MIN(ltv) AS min_ltv,
    MAX(ltv) AS max_ltv,
    AVG(ltv) AS avg_ltv
FROM hmda_analytical_prod;


SELECT
    loan_amount,
    property_value,
    ltv,
    action_taken_label,
    loan_purpose_label,
    debt_to_income_ratio,
    ltv_bucket
FROM hmda_analytical_prod
WHERE ltv > 1000
ORDER BY ltv DESC
LIMIT 20;

SELECT
    CASE
        WHEN ltv > 1000 THEN '>1000%'
        WHEN ltv > 500 THEN '500%-1000%'
        WHEN ltv > 100 THEN '100%-500%'
        WHEN ltv > 90 THEN '90%-100%'
        WHEN ltv > 80 THEN '80%-90%'
        WHEN ltv > 60 THEN '60%-80%'
        ELSE '<=60%'
    END AS ltv_range,
    COUNT(*) AS applications
FROM hmda_analytical_prod
WHERE ltv IS NOT NULL
GROUP BY ltv_range
ORDER BY applications DESC;

SELECT
    loan_amount,
    property_value,
    ltv,
    ltv_bucket
FROM hmda_analytical_prod
WHERE ltv > 1000
ORDER BY ltv DESC
LIMIT 20;

SELECT
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan,
    AVG(loan_amount) AS avg_loan,
    MIN(property_value) AS min_property,
    MAX(property_value) AS max_property,
    AVG(property_value) AS avg_property
FROM hmda_analytical_prod;

SELECT
    property_value,
    COUNT(*) AS applications,
    MIN(loan_amount) AS min_loan,
    MAX(loan_amount) AS max_loan,
    AVG(loan_amount) AS avg_loan
FROM hmda_analytical_prod
WHERE property_value IS NOT NULL
  AND property_value <= 50000
GROUP BY property_value
ORDER BY property_value
LIMIT 30;


SELECT
    CASE
        WHEN property_value < 10000 THEN '<$10K'
        WHEN property_value < 25000 THEN '$10K-$25K'
        WHEN property_value < 50000 THEN '$25K-$50K'
        WHEN property_value < 100000 THEN '$50K-$100K'
        ELSE '>= $100K'
    END AS property_value_band,
    COUNT(*) AS applications
FROM hmda_analytical_prod
WHERE property_value IS NOT NULL
GROUP BY property_value_band
ORDER BY
    CASE property_value_band
        WHEN '<$10K' THEN 1
        WHEN '$10K-$25K' THEN 2
        WHEN '$25K-$50K' THEN 3
        WHEN '$50K-$100K' THEN 4
        ELSE 5
    END;
    
use hmda_credit_risk;

SELECT
    action_taken_label,
    COUNT(*) AS applications,
    AVG(ltv) AS avg_ltv,
    MAX(ltv) AS max_ltv
FROM hmda_analytical_prod
WHERE ltv > 1000
GROUP BY action_taken_label
ORDER BY applications DESC;

SELECT
    COUNT(*) AS extreme_ltv_decisioned,
    SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END) AS denied,
    SUM(CASE WHEN action_taken = 1 THEN 1 ELSE 0 END) AS originated,
    ROUND(
        SUM(CASE WHEN action_taken = 3 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS denial_rate
FROM hmda_analytical_prod
WHERE ltv > 1000
  AND decisioned = 1;
  
SELECT
    CASE
        WHEN property_value < 10000 THEN '<$10K'
        WHEN property_value < 25000 THEN '$10K-$25K'
        WHEN property_value < 50000 THEN '$25K-$50K'
        ELSE '>= $50K'
    END AS property_value_band,
    COUNT(*) AS extreme_ltv_applications
FROM hmda_analytical_prod
WHERE ltv > 1000
GROUP BY property_value_band
ORDER BY extreme_ltv_applications DESC;

SELECT
    COUNT(*) AS extreme_ltv_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM hmda_analytical_prod),
        4
    ) AS pct_of_all_applications
FROM hmda_analytical_prod
WHERE ltv > 1000;

ALTER TABLE hmda_analytical_prod
ADD COLUMN ltv_quality_flag VARCHAR(30);

UPDATE hmda_analytical_prod
SET ltv_quality_flag =
    CASE
        WHEN ltv IS NULL THEN 'Missing'
        WHEN ltv > 1000 THEN 'Extreme >1000%'
        WHEN ltv > 100 THEN 'High >100%'
        ELSE 'Valid'
    END;
    
SET SQL_SAFE_UPDATES = 0;


SELECT
    ltv_quality_flag,
    COUNT(*) AS applications
FROM hmda_analytical_prod
GROUP BY ltv_quality_flag
ORDER BY applications DESC;