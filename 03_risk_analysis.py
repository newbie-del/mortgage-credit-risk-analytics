import pandas as pd

file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

df = pd.read_csv(
    file_path,
    sep="|",
    nrows=10000,
    low_memory=False
)

# -----------------------------
# Create DTI analytical bucket
# -----------------------------

def classify_dti(value):
    if pd.isna(value):
        return "Missing"
    elif value == "<20%":
        return "<20%"
    elif value == "20%-<30%":
        return "20%-<30%"
    elif value == "30%-<36%":
        return "30%-<36%"
    elif value in [
        "36", "37", "38", "39", "40",
        "41", "42", "43", "44", "45",
        "46", "47", "48", "49"
    ]:
        return "36%-49%"
    elif value == "50%-60%":
        return "50%-60%"
    elif value == ">60%":
        return ">60%"
    else:
        return "Other"


df["dti_bucket"] = df["debt_to_income_ratio"].apply(classify_dti)

print("\nDTI bucket distribution:")
print(df["dti_bucket"].value_counts())

# -----------------------------
# Identify applications that
# reached an originated/denied decision
# -----------------------------

df["decisioned"] = df["action_taken"].isin([1, 3])

print("\nDecisioned status:")
print(df["decisioned"].value_counts())

print("Rows:", df.shape[0])
print("Columns:", df.shape[1])


# -----------------------------
# Create business labels
# -----------------------------

loan_purpose_mapping = {
    1: "Home Purchase",
    2: "Home Improvement",
    31: "Refinancing",
    4: "Other Purpose"
}

df["loan_purpose_label"] = df["loan_purpose"].map(loan_purpose_mapping)

print("\nLoan purpose labels:")
print(df["loan_purpose_label"].value_counts())

action_mapping = {
    1: "Loan Originated",
    2: "Approved but Not Accepted",
    3: "Application Denied",
    4: "Application Withdrawn",
    5: "File Closed for Incompleteness"
}

df["action_taken_label"] = df["action_taken"].map(action_mapping)

print("\nApplication outcome labels:")
print(df["action_taken_label"].value_counts())

# -----------------------------
# Core application KPIs
# -----------------------------

total_applications = len(df)
decisioned_applications = df["decisioned"].sum()
originated_applications = (df["action_taken"] == 1).sum()
denied_applications = (df["action_taken"] == 3).sum()

decisioned_denial_rate = (
    denied_applications / decisioned_applications * 100
)

kpi_summary = pd.DataFrame({
    "KPI": [
        "Total Applications",
        "Decisioned Applications",
        "Loans Originated",
        "Applications Denied",
        "Decisioned Denial Rate"
    ],
    "Value": [
        total_applications,
        decisioned_applications,
        originated_applications,
        denied_applications,
        round(decisioned_denial_rate, 2)
    ]
})

print("\n--- Core KPI Summary ---")
print(kpi_summary)

kpi_summary.to_csv(
    "kpi_summary_sample.csv",
    index=False
)

print("\nKPI summary saved as: kpi_summary_sample.csv")

# -----------------------------
# DTI Risk Analysis
# -----------------------------

dti_risk = (
    df[df["decisioned"]]
    .groupby("dti_bucket")["action_taken"]
    .agg(
        decisioned_applications="count",
        denied_applications=lambda x: (x == 3).sum()
    )
)

dti_risk["denial_rate"] = (
    dti_risk["denied_applications"]
    / dti_risk["decisioned_applications"]
    * 100
)

print("\n--- DTI Risk Analysis ---")
print(dti_risk.round(2))

dti_risk.to_csv(
    "dti_risk_analysis_sample.csv"
)

print("\nDTI risk analysis saved as: dti_risk_analysis_sample.csv")

# -----------------------------
# Loan Purpose Risk Analysis
# -----------------------------

purpose_risk = (
    df[df["decisioned"]]
    .groupby("loan_purpose_label")["action_taken"]
    .agg(
        decisioned_applications="count",
        denied_applications=lambda x: (x == 3).sum()
    )
)

purpose_risk["denial_rate"] = (
    purpose_risk["denied_applications"]
    / purpose_risk["decisioned_applications"]
    * 100
)

print("\n--- Loan Purpose Risk Analysis ---")
print(purpose_risk.round(2))

purpose_risk.to_csv(
    "loan_purpose_risk_analysis_sample.csv"
)

print("\nLoan purpose risk analysis saved as: loan_purpose_risk_analysis_sample.csv")

# -----------------------------
# Calculate Loan-to-Value (LTV)
# -----------------------------

df["ltv"] = (
    df["loan_amount"] / df["property_value"]
) * 100

print("\n--- LTV Summary ---")
print(df["ltv"].describe())

print("\n--- Highest LTV Values ---")
print(
    df["ltv"]
    .sort_values(ascending=False)
    .head(20)
)

print("\n--- Lowest LTV Values ---")
print(
    df["ltv"]
    .sort_values()
    .head(20)
)

print("\n--- Extreme LTV Records ---")

extreme_ltv = df[
    df["ltv"] > 100
][[
    "loan_amount",
    "property_value",
    "ltv",
    "action_taken",
    "loan_purpose",
    "occupancy_type",
    "lien_status",
    "debt_to_income_ratio"
]].sort_values("ltv", ascending=False)

print(extreme_ltv.head(20))

print("\n--- LTV > 100% Check ---")

ltv_over_100 = (df["ltv"] > 100).sum()
ltv_available = df["ltv"].notna().sum()

print("LTV records available:", ltv_available)
print("LTV > 100%:", ltv_over_100)
print(
    "Percentage of available LTV records > 100%:",
    round(ltv_over_100 / ltv_available * 100, 2),
    "%"
)


# -----------------------------
# Create LTV Risk Buckets
# -----------------------------

def classify_ltv(value):
    if pd.isna(value):
        return "Missing"
    elif value <= 60:
        return "<=60%"
    elif value <= 80:
        return "60%-80%"
    elif value <= 90:
        return "80%-90%"
    elif value <= 100:
        return "90%-100%"
    else:
        return ">100%"


df["ltv_bucket"] = df["ltv"].apply(classify_ltv)

print("\n--- LTV Bucket Distribution ---")
print(df["ltv_bucket"].value_counts())

print("\n--- Denial Rate by LTV Bucket ---")

ltv_risk = (
    df[df["decisioned"]]
    .groupby("ltv_bucket")["action_taken"]
    .agg(
        decisioned_applications="count",
        denied_applications=lambda x: (x == 3).sum()
    )
)

ltv_risk["denial_rate"] = (
    ltv_risk["denied_applications"]
    / ltv_risk["decisioned_applications"]
    * 100
)

print(ltv_risk.round(2))

print("\n--- LTV Bucket vs Loan Purpose ---")

ltv_purpose = (
    df[df["decisioned"]]
    .groupby(["ltv_bucket", "loan_purpose_label"])["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

ltv_purpose["denial_rate"] = (
    ltv_purpose["denied"]
    / ltv_purpose["applications"]
    * 100
)

print(ltv_purpose.round(2))

print("\n--- LTV Bucket Composition by Loan Purpose ---")

ltv_purpose_share = pd.crosstab(
    df[df["decisioned"]]["ltv_bucket"],
    df[df["decisioned"]]["loan_purpose_label"],
    normalize="index"
) * 100

print(ltv_purpose_share.round(2))

ltv_risk.to_csv(
    "ltv_risk_analysis_sample.csv"
)

print("\nLTV risk analysis saved as: ltv_risk_analysis_sample.csv")


df.to_csv(
    "hmda_analysis_sample.csv",
    index=False
)

print("\nAnalysis sample saved as: hmda_analysis_sample.csv")

print("\n--- Denial Reasons ---")

denied_df = df[df["action_taken"] == 3]

denial_reason_columns = [
    "denial_reason_1",
    "denial_reason_2",
    "denial_reason_3",
    "denial_reason_4"
]

for column in denial_reason_columns:
    print(f"\n{column}")
    print(denied_df[column].value_counts(dropna=False).head(15))

    print("\n--- Combined Denial Reason Analysis ---")

reason_counts = {}

for column in denial_reason_columns:
    for reason in denied_df[column].dropna():
        reason = int(reason)
        reason_counts[reason] = reason_counts.get(reason, 0) + 1

denial_reason_summary = pd.DataFrame(
    list(reason_counts.items()),
    columns=["denial_reason_code", "count"]
)

denial_reason_summary = denial_reason_summary.sort_values(
    by="count",
    ascending=False
)

denial_reason_summary.to_csv(
    "denial_reason_summary_sample.csv",
    index=False
)

print(denial_reason_summary)