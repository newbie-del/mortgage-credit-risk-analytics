\# Data Sources



\## Primary Dataset



The project uses the \*\*2024 HMDA Dynamic National Loan-Level Dataset\*\* published by the Federal Financial Institutions Examination Council (FFIEC).



The dataset contains national mortgage application and loan-level records and is updated periodically to incorporate late submissions and resubmissions.



Official source:



https://ffiec.cfpb.gov/data-publication/dynamic-national-loan-level-dataset/2024



\## Official HMDA Data Browser



The FFIEC 2024 HMDA Data Browser was used as an official reference for understanding published HMDA data and validating analytical definitions.



https://ffiec.cfpb.gov/data-browser/data/2024?category=nationwide



The Data Browser and the Dynamic National Loan-Level Dataset should not be treated as interchangeable project datasets. The analytical pipeline uses the Dynamic National Loan-Level Dataset as its primary raw input.



\## HMDA Filing Instructions Guide



The official 2024 HMDA Filing Instructions Guide was used to interpret HMDA field definitions and coding values.



https://files.ffiec.cfpb.gov/documentation/2024-hmda-fig.pdf



\## Dataset Used in This Project



Raw input:



`data/raw/2024\_lar.txt`



The raw file is pipe-delimited and contains 99 columns.



The dataset processed by the project contains:



\- 12,260,627 application records

\- 2024 reporting year

\- National loan/application-level coverage



\## Source Usage



The source data was used for:



\- Application outcome analysis

\- Loan-purpose risk analysis

\- DTI risk analysis

\- LTV analysis

\- Denial-reason analysis

\- Geographic analysis

\- Product and pricing analysis

\- Demographic analysis

\- Risk-factor interaction analysis

\- Portfolio risk concentration



\## Important Source Limitations



The analytical dataset does not contain an actual applicant credit-score value. It contains the reported applicant credit-score model type.



Therefore, the project does not claim to analyze actual applicant credit-score levels.



Race and ethnicity analysis uses the first-reported applicant fields available in the analytical dataset rather than attempting to reconstruct HMDA's full derived demographic classifications.

