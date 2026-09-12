\# Analytical Data Dictionary



\## Core Application Fields



| Field | Description |

|---|---|

| activity\_year | HMDA reporting year |

| lei | Legal Entity Identifier |

| derived\_msa\_md | Derived metropolitan statistical area / metropolitan division |

| state\_code | State code |

| county\_code | County code |

| derived\_dwelling\_category | Derived dwelling category |

| action\_taken | HMDA application action code |

| loan\_type | Mortgage loan type |

| loan\_purpose | Loan purpose code |

| lien\_status | Lien status |

| loan\_amount | Reported loan amount |

| interest\_rate | Reported interest rate |

| rate\_spread | Rate spread between APR and applicable APOR |

| property\_value | Reported property value |

| occupancy\_type | Property occupancy type |

| debt\_to\_income\_ratio | Reported debt-to-income ratio |

| applicant\_credit\_score\_type | Reported applicant credit-score model type |

| applicant\_ethnicity\_1 | First-reported applicant ethnicity |

| applicant\_race\_1 | First-reported applicant race |

| applicant\_sex | Applicant sex |

| applicant\_age | Applicant age category |

| denial\_reason\_1..4 | Reported denial reason fields |



\## Derived Analytical Fields



| Field | Description |

|---|---|

| decisioned | Indicates whether the application belongs to the decisioned population used for denial-rate analysis |

| loan\_purpose\_label | Human-readable loan-purpose category |

| action\_taken\_label | Human-readable HMDA action category |

| dti\_bucket | Analytical DTI risk band |

| ltv | Derived loan-to-value ratio: loan amount / property value × 100 |

| ltv\_bucket | Analytical LTV risk band |

| ltv\_quality\_flag | Data-quality classification for the derived LTV |



\## Outcome Definition



For the main risk analysis:



`decisioned = originated + approved but not accepted + denied`



Decisioned denial rate:



`denied / decisioned × 100`



\## DTI Buckets



\- `<20%`

\- `20%-<30%`

\- `30%-<36%`

\- `36%-49%`

\- `50%-60%`

\- `>60%`

\- `Missing`

\- `Exempt`



\## LTV Quality Flags



\- `Valid`

\- `Missing`

\- `High >100%`

\- `Extreme >1000%`



Extreme LTV observations are separately identified because they can materially distort standard LTV visualizations.



\## Important Interpretation Notes



`applicant\_credit\_score\_type` identifies the credit-score model type. It is not an actual applicant credit score.



`ltv` is a derived analytical metric. It should not be interpreted as the official HMDA CLTV field.



Denial-reason counts represent reason occurrences. A single denied application can contain multiple reported reasons.



Race and ethnicity analysis uses first-reported applicant fields available in the analytical dataset.

