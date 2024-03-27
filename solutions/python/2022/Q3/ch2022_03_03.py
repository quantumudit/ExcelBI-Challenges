"""
The script solves the challenge by performing caesar cipher encoding for the
given numbers and their respective shifts
"""

# Import necessary libraries
import pandas as pd


def caesar_cipher_encode(number: int, shift: int) -> int:
    """
    Encode a given number using the Caesar cipher with a specified shift.

    Args:
        number (int): The number to be encoded.
        shift (int): The shift value for the Caesar cipher encoding.

    Returns:
        str: The encoded number.
    """
    encoded_numbers = []
    for num in str(number):
        shifted_val = int(num) + shift
        shifted_num = shifted_val % 10 if shifted_val > 9 else shifted_val
        encoded_numbers.append(shifted_num)
    return "".join(map(str, encoded_numbers))


if __name__ == "__main__":
    # Loading the data
    DATA_PATH = "data/2022/Q3/ch2022_03_03.csv"
    df = pd.read_csv(DATA_PATH)

    # Creating a column with shifted numbers
    df["Shifted Numbers"] = df.apply(
        lambda row: caesar_cipher_encode(row["Text"], row["Shift"]), axis=1
    )
    # Print the dataframe
    print(df)
