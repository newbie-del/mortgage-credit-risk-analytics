"""
#Inspect the first 5 lines of the raw data file.
file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

with open(file_path, "r", encoding="utf-8") as file:
    for i in range(5):
        line = file.readline()
        print(line)
"""



"""
file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

with open(file_path, "r", encoding="utf-8") as file:
    row_count = sum(1 for _ in file)

print("Total rows:", row_count)
"""



file_path = r"D:\DA-projects\Bank-system\data\raw\2024_lar.txt"

with open(file_path, "r", encoding="utf-8") as file:
    header = file.readline().strip()

columns = header.split("|")

print("Number of columns:", len(columns))

print("\nColumn names:")
for number, column in enumerate(columns, start=1):
    print(number, column)