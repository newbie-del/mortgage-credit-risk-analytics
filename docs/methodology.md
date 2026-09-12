\# Analytical Methodology



\## Project Scope



This project analyzes 2024 HMDA mortgage application data to understand observed credit-risk patterns across underwriting factors, loan characteristics, geography, demographics, and portfolio segments.



The analysis is descriptive and observational. It identifies patterns in application outcomes rather than estimating causal effects.



\## Outcome Definition



The primary risk metric is the decisioned denial rate:



Denial Rate = Denied Applications / Decisioned Applications × 100



Decisioned applications include applications with:



\- Loan originated

\- Approved but not accepted

\- Denied



This denominator is used consistently across the main risk analyses.



\## Loan Purpose Analysis



Loan purposes are mapped using the official 2024 HMDA coding definitions:



\- Home Purchase

\- Home Improvement

\- Refinancing

\- Cash-out Refinancing

\- Other Purpose

\- Not Applicable



\## DTI Analysis



Debt-to-income ratio is grouped into analytical risk bands:



\- <20%

\- 20%-<30%

\- 30%-<36%

\- 36%-49%

\- 50%-60%

\- >60%

\- Missing

\- Exempt



Missing and Exempt values are kept separate because they represent different reporting conditions.



\## LTV Analysis



The project derives:



LTV = Loan Amount / Property Value × 100



Analytical LTV bands are:



\- ≤60%

\- 60%-80%

\- 80%-90%

\- 90%-100%

\- >100%

\- Missing



Extreme values above 1000% are separately flagged and excluded from standard LTV risk visuals.



The derived LTV metric should not be confused with the official HMDA CLTV field.



\## Denial Reasons



Denial reasons are analyzed as reason occurrences across denied applications.



Because a denied application can contain multiple denial reasons, reason counts represent occurrences rather than unique denied applications.



\## Geographic Analysis



State-level denial rates are compared with the national decisioned denial rate.



Additional standardized comparisons use a common DTI mix to investigate whether observed geographic differences remain after accounting for differences in DTI composition.



These comparisons are descriptive and should not be interpreted as causal geographic effects.



\## Demographic Analysis



Race and ethnicity analysis uses the first-reported applicant race and ethnicity fields available in the analytical dataset.



Standardized demographic comparisons use common loan-purpose and loan-type segments to reduce composition effects.



The analysis does not estimate discrimination or causal effects.



\## Risk Segmentation



Risk-factor interaction analysis examines combinations such as:



\- DTI × LTV

\- DTI × Loan Purpose

\- Loan Purpose × Loan Type



The purpose is to identify concentrated high-risk segments rather than build a predictive credit model.



\## Data Quality



The project explicitly tracks:



\- Missing values

\- Exempt values

\- Extreme LTV observations

\- Zero interest-rate observations

\- Extreme rate-spread observations

\- Small-volume analytical segments



Data-quality decisions are documented rather than silently removing observations.



\## Interpretation



All findings should be interpreted as observed relationships within the 2024 HMDA dataset.



No conclusion in this project should be interpreted as:



\- A causal relationship

\- A lending-policy recommendation for automatic approval or denial

\- Evidence of unlawful discrimination

\- A substitute for formal fair-lending or compliance analysis

