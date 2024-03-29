"""
This script provides functions to analyze and transform text data. It solves
the challenge by leveraging the functions to transform the given text data.
"""

import string

import pandas as pd


def char_type(char: str) -> str:
    """
    This function takes a single character as input and returns
    the type of the character.

    Args:
        char (str): A single character string.

    Returns:
        str: The type of the character. It returns "lower" if the character is a
        lowercase letter, "upper" if the character is an uppercase letter, "digit"
        if the character is a digit, and "special" for any other characters.
    """
    if char in string.ascii_lowercase:
        group = "lower"
    elif char in string.ascii_uppercase:
        group = "upper"
    elif char in string.digits:
        group = "digit"
    else:
        group = "special"
    return group


def text_transform(text: str) -> str:
    """
    This function transforms a given text by inserting a comma between characters
    of different types.

    Args:
        text (str): The input string that needs to be transformed.

    Returns:
        str: The transformed string with commas inserted between characters
        of different types.
    """
    text_len = len(text)
    letters = ""
    for idx in range(text_len):
        current_char_type = char_type(text[idx])
        prev_char_type = char_type(text[idx - 1])
        if idx > 0:
            if current_char_type != prev_char_type:
                letters += f", {text[idx]}"
            else:
                letters += text[idx]
        else:
            letters += text[idx]
    return letters


if __name__ == "__main__":
    # Loading the data
    DATA_PATH = "./data/2024/Q1/ch2024_01_04.csv"
    df = pd.read_csv(DATA_PATH)
    data = df["Data"]

    # Transform the texts
    transformed_text = [text_transform(text) for text in data]

    # Print the transformed texts
    print("\n".join(transformed_text))
