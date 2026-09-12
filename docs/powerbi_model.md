\# Power BI Analytical Model



\## Reporting Approach



The Power BI report uses pre-aggregated MySQL analytical views designed around individual business questions.



The report does not directly relate every analytical view to every other view because the views operate at different grains.



\## Analytical Views



The reporting layer includes views for:



\- Executive credit-risk KPIs

\- Demographic risk

\- DTI risk

\- Geographic risk

\- Lien risk

\- Loan-purpose risk

\- Loan-type risk

\- LTV risk

\- Occupancy risk

\- Risk concentration

\- Denial reasons

\- DTI × LTV interactions

\- Standardized demographic comparisons

\- Pricing risk

\- Loan-purpose × loan-type risk

\- Denial reasons by loan purpose

\- DTI by loan purpose



\## Report Pages



\### Executive Risk Overview



Provides the portfolio-level risk snapshot, including:



\- Total applications

\- Decisioned applications

\- Originated loans

\- Denied applications

\- Decisioned denial rate

\- Denial share

\- Loan-purpose risk

\- DTI risk

\- LTV risk

\- Geographic risk



\### Risk Drivers \& Concentration



Focuses on:



\- Denial reasons

\- Loan-type risk

\- DTI × LTV risk

\- Portfolio concentration

\- Denied applications by loan purpose



\### Executive Insights \& Recommendations



Summarizes the most important findings and translates them into business-oriented recommendations.



\### Demographic \& Fair Lending Analysis



Examines observed denial-rate differences across:



\- Race

\- Sex

\- Ethnicity

\- Age



It also presents standardized demographic comparisons.



\### Product \& Pricing Risk



Examines:



\- Loan type

\- Occupancy

\- Lien status

\- Loan purpose × loan type

\- Interest rates

\- Rate spreads

\- Zero-rate originated loans



\### Risk Segmentation \& Deep Dive



Combines:



\- Denial reasons by purpose

\- Purpose × loan type

\- DTI × purpose

\- Portfolio exposure vs risk



\### Loan Purpose Drill-Through



Provides a detailed investigation of a selected loan purpose.



The drill-through page dynamically updates:



\- Applications denied

\- Portfolio volume share

\- Denial rate

\- DTI denial rate

\- Denial reasons

\- Loan-type denial rates



\## Interactive Design



The report uses targeted slicers where a meaningful analytical relationship exists.



The executive overview intentionally remains a static executive snapshot rather than forcing unrelated aggregate views into a single filter context.



\## Key DAX Techniques



The report uses measures for:



\- Executive KPIs

\- Decisioned denial rate

\- Drill-through KPIs

\- Drill-through DTI analysis

\- Drill-through denial-reason analysis



`TREATAS` is used where the drill-through selection needs to be passed into an analytical view with a different grain.



\## Interpretation



Power BI is used as the reporting and exploration layer.



The underlying SQL views remain the primary analytical definitions, while Power BI provides interactive visualization and drill-through investigation.

