import pandas as pd
from rich.pretty import pprint

# Read the input CSV file into a DataFrame
data = pd.read_csv("2024_04_04_data.csv")

# List to store processed columns
processed_columns = []

# Iterate through the first three columns (N1, N2, N3)
for col_index in range(3):
    # Generate the column name dynamically
    column_name = f"N{col_index + 1}"

    # Sort the column values and drop missing entries
    sorted_values = data[column_name].sort_values().dropna()

    # Separate odd and even numbers, then concatenate them
    rearranged_values = pd.concat(
        [
            sorted_values[sorted_values % 2 != 0],
            sorted_values[sorted_values % 2 == 0],
        ]
    ).reset_index(drop=True)

    # Append the processed column to the list
    processed_columns.append(rearranged_values)

# Combine all processed columns into a single DataFrame with datatype change
result = (
    pd.concat(processed_columns, axis=1).fillna(0).astype(int).replace(0, "")
)

# Display the final DataFrame
pprint(result)
