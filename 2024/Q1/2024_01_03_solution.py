"""
This module provides a function to determine if a given year is a leap year in either
the Gregorian or Revised Julian calendar, but not both.

This script solves the challenge by filtering the leap years based on the
given condition from 1901 to 9999.
"""


def is_conditional_leap_year(year: int) -> bool:
    """
    This function checks if a year is a leap year in either Gregorian or
    Revised Julian calendar, but not both.

    Args:
        year (int):The year value

    Returns:
        bool: True if the year is a leap year according to the provided conditions,
        False otherwise.
    """
    if (year % 400 == 0) and (year % 900 == 200 or year % 900 == 600):
        conditional_leap_year = False
    else:
        # Gregorian calendar century leap year condition
        if year % 400 == 0:
            conditional_leap_year = True
        # Revised Julian calendar century leap year condition
        elif year % 900 == 200 or year % 900 == 600:
            conditional_leap_year = True
        else:
            conditional_leap_year = False
    return conditional_leap_year


if __name__ == "__main__":

    # Loop and get the conditional leap years between 1901 and 9999
    leap_years = [year for year in range(1901, 10000) if is_conditional_leap_year(year)]

    # Print the years
    print("\n".join(map(str, leap_years)))
