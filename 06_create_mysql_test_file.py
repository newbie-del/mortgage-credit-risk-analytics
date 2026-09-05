import pandas as pd

source_file = r"D:\DA-projects\Bank-system\hmda_analytical_dataset.csv"

output_file = r"D:\DA-projects\Bank-system\hmda_mysql_test.csv"

df = pd.read_csv(
    source_file,
    nrows=1000,
    low_memory=False
)

df.to_csv(
    output_file,
    index=False
)

print("Test file created.")
print("Rows:", len(df))
print("Columns:", len(df.columns))
print("File:", output_file)