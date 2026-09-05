import pandas as pd

file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

columns_needed = [
    "activity_year",
    "lei",
    "state_code",
    "county_code",
    "derived_msa_md",
    "derived_dwelling_category",

    "action_taken",
    "loan_type",
    "loan_purpose",
    "lien_status",
    "occupancy_type",

    "loan_amount",
    "property_value",
    "interest_rate",
    "rate_spread",
    "debt_to_income_ratio",

    "applicant_credit_score_type",

    "applicant_ethnicity_1",
    "applicant_race_1",
    "applicant_sex",
    "applicant_age",

    "denial_reason_1",
    "denial_reason_2",
    "denial_reason_3",
    "denial_reason_4"
]

chunk_size = 100000
total_rows = 0

output_file = "hmda_analytical_dataset.csv"

first_chunk = True

print("Starting full-data chunk processing...\n")


# -----------------------------
# DTI bucket function
# -----------------------------
def classify_dti(value):

    if pd.isna(value):
        return "Missing"

    value = str(value).strip()

    if value == "<20%":
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


# -----------------------------
# LTV bucket function
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


# -----------------------------
# Process data in chunks
# -----------------------------
for chunk_number, chunk in enumerate(
    pd.read_csv(
        file_path,
        sep="|",
        usecols=columns_needed,
        chunksize=chunk_size,
        low_memory=False
    ),
    start=1
):

    total_rows += len(chunk)

    # -----------------------------
    # Derived analytical fields
    # -----------------------------

    # Decisioned applications
    chunk["decisioned"] = chunk["action_taken"].isin([1, 3])

    # -----------------------------
    # Loan purpose labels
    # -----------------------------
    loan_purpose_mapping = {
        1: "Home Purchase",
        2: "Home Improvement",
        31: "Refinancing",
        4: "Other Purpose"
    }

    chunk["loan_purpose_label"] = (
        chunk["loan_purpose"].map(loan_purpose_mapping)
    )

    # -----------------------------
    # Action taken labels
    # -----------------------------
    action_mapping = {
        1: "Loan Originated",
        2: "Approved but Not Accepted",
        3: "Application Denied",
        4: "Application Withdrawn",
        5: "File Closed for Incompleteness"
    }

    chunk["action_taken_label"] = (
        chunk["action_taken"].map(action_mapping)
    )

    # -----------------------------
    # DTI buckets
    # -----------------------------
    chunk["dti_bucket"] = (
        chunk["debt_to_income_ratio"]
        .apply(classify_dti)
    )

    # -----------------------------
    # LTV calculation
    # -----------------------------

    chunk["loan_amount"] = pd.to_numeric(
        chunk["loan_amount"],
        errors="coerce"
    )

    chunk["property_value"] = pd.to_numeric(
        chunk["property_value"],
        errors="coerce"
    )
    chunk["ltv"] = (
        chunk["loan_amount"]
        / chunk["property_value"]
        * 100
    )

    # -----------------------------
    # LTV buckets
    # -----------------------------
    chunk["ltv_bucket"] = (
        chunk["ltv"]
        .apply(classify_ltv)
    )

    chunk.to_csv(
    output_file,
    mode="w" if first_chunk else "a",
    header=first_chunk,
    index=False
)

    first_chunk = False

    # -----------------------------
    # Progress
    # -----------------------------
    print(
        f"Chunk {chunk_number}: "
        f"{len(chunk):,} rows | "
        f"Total processed: {total_rows:,}"
    )


print("\nProcessing complete.")
print(f"Total rows processed: {total_rows:,}")
