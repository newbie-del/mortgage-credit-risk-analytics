\# Reproducibility Guide



\## 1. Obtain the Raw Data



Download the 2024 HMDA Dynamic National Loan-Level Dataset from the official FFIEC source.



Place the raw LAR file at:



`data/raw/2024\_lar.txt`



Raw datasets are intentionally excluded from Git because of their size.



\## 2. Python Processing



The Python pipeline is stored in:



`python/`



Main stages:



1\. `01\_inspect\_raw\_data.py`

2\. `02\_profile\_sample.py`

3\. `03\_risk\_analysis.py`

4\. `04\_build\_full\_dataset.py`

5\. `05\_validate\_analytical\_dataset.py`

6\. `06\_create\_mysql\_test\_file.py`



The full analytical dataset is generated in chunks to avoid loading the entire raw file into memory at once.



\## 3. MySQL



The project uses MySQL 8.



Create the database:



`hmda\_credit\_risk`



The SQL scripts in `sql/` contain the analytical queries and reporting views.



The main production table is:



`hmda\_analytical\_prod`



\## 4. SQL Analysis



The SQL workflow covers:



\- Executive KPIs

\- Loan-purpose risk

\- DTI risk

\- LTV risk

\- Denial reasons

\- Geographic risk

\- Loan-type risk

\- Occupancy risk

\- Lien risk

\- Pricing

\- Applicant age

\- Applicant sex

\- Applicant race

\- Applicant ethnicity

\- Risk-factor interactions

\- Geographic segmentation

\- Portfolio concentration

\- Power BI analytical views



\## 5. Power BI



The completed Power BI report is:



`Power-Bi/Mortgage\_Credit\_Risk\_Analytics.pbix`



The report consumes pre-aggregated analytical views from MySQL rather than connecting directly to the raw application-level table for every visual.



This keeps the reporting layer aligned with the analytical grain of each business question.



\## 6. Sample Data



Representative samples are provided under:



`data/samples/`



These files allow the repository structure and example outputs to be reviewed without distributing the full national dataset.



\## 7. Important Reproduction Notes



The raw HMDA dataset may be updated by FFIEC after initial publication.



For exact reproduction, use the same 2024 Dynamic National Loan-Level Dataset version used when this analysis was created.



Power BI visuals may also depend on the local MySQL connection and credentials, which are intentionally not stored in the repository.

