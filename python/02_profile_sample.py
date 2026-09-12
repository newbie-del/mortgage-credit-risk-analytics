import pandas as pd

file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

df = pd.read_csv(
    file_path,
    sep="|",
    nrows=10000,
    low_memory=False
)

print("Rows:", df.shape[0])
print("Columns:", df.shape[1])

print("\nFirst 5 rows:")
print(df.head())

print("\nData types:")
print(df.dtypes)

print("\nMissing values:")
missing = df.isna().sum()

print(missing.sort_values(ascending=False))

print("\nMissing percentage:")

missing_pct = (df.isna().mean() * 100).sort_values(ascending=False)

print(missing_pct.head(10))

# Create data profiling summary

profile = pd.DataFrame({
    "column": df.columns,
    "data_type": df.dtypes.astype(str).values,
    "missing_count": df.isna().sum().values,
    "missing_percentage": (df.isna().mean() * 100).values,
    "unique_values": df.nunique(dropna=True).values
})

profile = profile.sort_values(
    by="missing_percentage",
    ascending=False
)

profile.to_csv(
    "sample_data_profile.csv",
    index=False
)

print("\nProfiling report created:")
print(profile.head(15))

# Inspect important categorical fields

categorical_columns = [
    "action_taken",
    "loan_type",
    "loan_purpose",
    "lien_status",
    "occupancy_type",
    "derived_dwelling_category",
    "applicant_credit_score_type"
]

for column in categorical_columns:
    print(f"\n--- {column} ---")
    print(df[column].value_counts(dropna=False).head(20))


for column in df.columns:
    if "credit_score" in column:
        print(column)

for column in df.columns:
    if "score" in column.lower() or "credit" in column.lower():
        print(column)


important_columns = [
    "loan_amount",
    "property_value",
    "interest_rate",
    "rate_spread",
    "debt_to_income_ratio",
    "action_taken",
    "loan_purpose",
    "occupancy_type",
    "lien_status"
]

print("\n--- Important analytical columns ---")

for column in important_columns:
    print(f"\n{column}")
    print("Data type:", df[column].dtype)
    print("Missing:", df[column].isna().sum())
    print("Unique:", df[column].nunique())
    print(df[column].head(5).tolist())


    action_mapping = {
    1: "Loan originated",
    2: "Approved but not accepted",
    3: "Application denied",
    4: "Application withdrawn",
    5: "File closed for incompleteness"
}

df["action_taken_label"] = df["action_taken"].map(action_mapping)

print("\n--- Application Outcomes ---")
print(df["action_taken_label"].value_counts())

print("\n--- Application Outcome Percentages ---")

outcome_pct = (
    df["action_taken_label"]
    .value_counts(normalize=True)
    .mul(100)
    .round(2)
)

print(outcome_pct)

originated = (df["action_taken"] == 1).sum()
denied = (df["action_taken"] == 3).sum()

denial_rate = denied / (denied + originated) * 100

print("\n--- Denial Rate ---")
print(f"Originated: {originated}")
print(f"Denied: {denied}")
print(f"Denial Rate: {denial_rate:.2f}%")

print("\n--- Loan Purpose vs Application Outcome ---")

purpose_outcome = pd.crosstab(
    df["loan_purpose"],
    df["action_taken_label"]
)

print(purpose_outcome)

print("\n--- Denial Rate by Loan Purpose ---")

purpose_denial = (
    df.groupby("loan_purpose")["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

purpose_denial["denial_rate"] = (
    purpose_denial["denied"]
    / purpose_denial["applications"]
    * 100
)

print(purpose_denial)


loan_purpose_mapping = {
    1: "Home Purchase",
    2: "Home Improvement",
    31: "Refinancing",
    4: "Other Purpose"
}

purpose_denial.index = purpose_denial.index.map(loan_purpose_mapping)

print("\n--- Business View: Denial Rate by Loan Purpose ---")
print(purpose_denial.sort_values("denial_rate", ascending=False))

print("\n--- Debt-to-Income Ratio Values ---")
print(df["debt_to_income_ratio"].value_counts(dropna=False).sort_index())


print("\n--- DTI Data Types and Examples ---")
print("Data type:", df["debt_to_income_ratio"].dtype)

print("\nUnique values:")
print(sorted(df["debt_to_income_ratio"].dropna().unique(), key=str))

def classify_dti(value):
    if pd.isna(value):
        return "Missing"
    elif value == "<20%":
        return "<20%"
    elif value == "20%-<30%":
        return "20%-<30%"
    elif value == "30%-<36%":
        return "30%-<36%"
    elif value in ["36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49"]:
        return "36%-49%"
    elif value == "50%-60%":
        return "50%-60%"
    elif value == ">60%":
        return ">60%"
    else:
        return "Other"


df["dti_bucket"] = df["debt_to_income_ratio"].apply(classify_dti)

print("\n--- DTI Buckets ---")
print(df["dti_bucket"].value_counts())

print("\n--- Denial Rate by DTI Bucket ---")

dti_analysis = (
    df.groupby("dti_bucket")["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

dti_analysis["denial_rate"] = (
    dti_analysis["denied"]
    / dti_analysis["applications"]
    * 100
)

print(dti_analysis)

print("\n--- DTI Bucket vs Loan Purpose ---")

dti_purpose = pd.crosstab(
    df["dti_bucket"],
    df["loan_purpose"]
)

print(dti_purpose)


print("\n--- Denial Rate: DTI Bucket × Loan Purpose ---")

dti_purpose_outcome = (
    df.groupby(["dti_bucket", "loan_purpose"])["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

dti_purpose_outcome["denial_rate"] = (
    dti_purpose_outcome["denied"]
    / dti_purpose_outcome["applications"]
    * 100
)

print(dti_purpose_outcome)


print("\n--- DTI Bucket vs Application Outcome ---")

dti_outcome = pd.crosstab(
    df["dti_bucket"],
    df["action_taken_label"]
)

print(dti_outcome)


print("\n--- Average Loan Amount by DTI Bucket ---")

dti_loan_amount = (
    df.groupby("dti_bucket")["loan_amount"]
    .agg(
        applications="count",
        average_loan_amount="mean",
        median_loan_amount="median"
    )
)

print(dti_loan_amount.round(2))

df["decisioned"] = df["action_taken"].isin([1, 3])

print("\n--- Decisioned Applications ---")
print(df["decisioned"].value_counts())


decisioned_dti = (
    df[df["decisioned"]]
    .groupby("dti_bucket")["action_taken"]
    .agg(
        decisioned_applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

decisioned_dti["denial_rate"] = (
    decisioned_dti["denied"]
    / decisioned_dti["decisioned_applications"]
    * 100
)

print("\n--- Decisioned Denial Rate by DTI ---")
print(decisioned_dti.round(2))


low_dti_analysis = (
    df[
        (df["decisioned"]) &
        (df["dti_bucket"].isin(["<20%", "20%-<30%", "30%-<36%", "36%-49%"]))
    ]
    .groupby(["dti_bucket", "loan_purpose"])["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

low_dti_analysis["denial_rate"] = (
    low_dti_analysis["denied"]
    / low_dti_analysis["applications"]
    * 100
)

print("\n--- Lower DTI vs Loan Purpose ---")
print(low_dti_analysis.round(2))

low_dti_lien = (
    df[
        (df["decisioned"]) &
        (df["dti_bucket"].isin(["<20%", "20%-<30%", "30%-<36%", "36%-49%"]))
    ]
    .groupby(["dti_bucket", "lien_status"])["action_taken"]
    .agg(
        applications="count",
        denied=lambda x: (x == 3).sum()
    )
)

low_dti_lien["denial_rate"] = (
    low_dti_lien["denied"]
    / low_dti_lien["applications"]
    * 100
)

print("\n--- Lower DTI vs Lien Status ---")
print(low_dti_lien.round(2))