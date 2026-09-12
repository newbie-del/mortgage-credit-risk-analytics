import pandas as pd
import os

file_path = r"D:\DA-projects\Bank-system\hmda_analytical_dataset.csv"

chunk_size = 100000

expected_rows = 12_260_627

total_rows = 0
chunk_number = 0

print("Starting analytical dataset validation...\n")

for chunk in pd.read_csv(
    file_path,
    chunksize=chunk_size,
    low_memory=False
):

    chunk_number += 1
    total_rows += len(chunk)

    # Check for duplicate rows within each chunk
    duplicate_rows = chunk.duplicated().sum()

    # Check for invalid LTV values
    invalid_ltv = (
        chunk["ltv"].notna()
        & ~chunk["ltv"].apply(lambda x: pd.notna(x))
    ).sum()

    print(
        f"Chunk {chunk_number}: "
        f"{len(chunk):,} rows | "
        f"Total checked: {total_rows:,}"
    )

print("\n--- Validation Summary ---")

print(f"Expected rows: {expected_rows:,}")
print(f"Actual rows:   {total_rows:,}")

if total_rows == expected_rows:
    print("Row count check: PASSED")
else:
    print("Row count check: FAILED")

print(f"\nFile size: {os.path.getsize(file_path) / (1024**3):.2f} GB")

print("\n--- Column Validation ---")

required_columns = [
    "decisioned",
    "loan_purpose_label",
    "action_taken_label",
    "dti_bucket",
    "ltv",
    "ltv_bucket"
]

first_chunk = pd.read_csv(
    file_path,
    nrows=5,
    low_memory=False
)

missing_columns = [
    column
    for column in required_columns
    if column not in first_chunk.columns
]

if not missing_columns:
    print("Required analytical columns: PASSED")
    print("All derived columns are present.")
else:
    print("Required analytical columns: FAILED")
    print("Missing columns:", missing_columns)  


print("\n--- Derived Field Sample Validation ---")

print("\nDecisioned:")
print(first_chunk["decisioned"].value_counts(dropna=False))

print("\nLoan Purpose:")
print(first_chunk["loan_purpose_label"].value_counts(dropna=False))

print("\nAction Taken:")
print(first_chunk["action_taken_label"].value_counts(dropna=False))

print("\nDTI Bucket:")
print(first_chunk["dti_bucket"].value_counts(dropna=False))

print("\nLTV Bucket:")
print(first_chunk["ltv_bucket"].value_counts(dropna=False))

print("\nLTV Sample:")
print(first_chunk["ltv"].head())