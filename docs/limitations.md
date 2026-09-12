\# Project Limitations



\## Dataset Scope



This project uses the 2024 HMDA Dynamic National Loan-Level Dataset. The analysis therefore represents the 2024 reporting period and should not automatically be generalized to other years.



\## Observational Analysis



The project identifies observed differences in denial rates and risk patterns.



These results are not causal estimates and should not be interpreted as proof that any individual factor causes an application outcome.



\## Credit Score Limitation



The available analytical dataset contains the applicant credit-score model type, but not the actual applicant credit-score value.



Consequently, the project does not perform applicant credit-score-level risk analysis.



\## Demographic Classification



Race and ethnicity analysis uses the first-reported applicant race and ethnicity fields available in the analytical dataset.



It does not reconstruct the full HMDA-derived race or ethnicity classifications.



\## Denial Reasons



An application can contain multiple denial reasons.



Therefore, denial-reason counts represent occurrences rather than unique denied applications.



\## LTV Limitation



The analytical LTV measure is derived as:



Loan Amount / Property Value × 100



This is an analytical metric and should not be confused with the official HMDA CLTV field.



Extreme LTV observations are separately flagged because they can disproportionately affect aggregate analysis.



\## Missing and Exempt Values



Missing, Not Applicable, and Exempt values are retained where analytically meaningful.



They should not automatically be interpreted as equivalent applicant or loan characteristics.



\## Geographic Comparisons



State-level differences can reflect differences in loan purpose, applicant mix, underwriting characteristics, product composition, and other factors.



Standardized comparisons reduce selected composition effects but do not establish causality.



\## Fair Lending Interpretation



Observed demographic differences should not be interpreted as evidence of unlawful discrimination.



Formal fair-lending analysis would require additional controls, methodology, institutional context, statistical testing, and appropriate compliance review.



\## Data Version



The Dynamic HMDA dataset can receive updates for late submissions and resubmissions.



Exact reproduction therefore depends on using the same dataset version used for the original analysis.



\## Production Use



This project is an analytical portfolio project and is not a production underwriting model.



The findings should not be used as an automated approval or denial decision system.

