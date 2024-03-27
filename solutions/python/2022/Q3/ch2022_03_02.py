"""
The script solves the challenge by keeping the words that has all the vowels in them
"""

# Import necessary libraries
import pandas as pd

# Loading the data
DATA_PATH = "data/2022/Q3/ch2022_03_02.csv"
words = pd.read_csv(DATA_PATH)["Words"]

# Filer words that has all the vowels
vowels = ["a", "e", "i", "o", "u"]
for word in words:
    if all([char in word.lower() for char in vowels]):
        print(word)
