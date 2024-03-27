"""
The script solves the challenge by finding the alphabet appearing against 2's
"""

# Import necessary libraries
import pandas as pd

# Loading the data
DATA_PATH = "data/2022/Q3/ch2022_03_01.csv"
df = pd.read_csv(DATA_PATH)

# Filter the dataframe for alphabets against 2's only
letters = df[df["Number"] == 2]["Data"].dropna()
alphas_only = letters[letters.str.isalpha()].reset_index(drop=True)

# Print the 5th alphabet
print(alphas_only[4])
