import pandas as pd
from rich.pretty import pprint

# Read the CSV file containing address data
address = pd.read_csv("2024_04_05_data.csv", encoding="cp1252")["String"]

# Define a regex pattern to extract zip codes & country names
zip_pattern = r"^(\d{5,8}).*|.*-\s(\d{5,8})|.*,\s(\d{5,8})"
country_pattern = r"^(\w*)$|^(\w*\s\w*)$|.*(Japan|United Kingdom|India)"

# Extract zip codes & country names using regex
zip_codes = address.str.extract(zip_pattern).bfill(axis=1).iloc[:, 0]
countries = (
    address.str.split(",")
    .str[-1]
    .str.strip()
    .str.extract(country_pattern)
    .bfill(axis=1)
    .iloc[:, 0]
)

# Create a DataFrame with zip codes & country names
result_df = pd.DataFrame({"Zip": zip_codes, "Country": countries})

# Display the final DataFrame
pprint(result_df)
