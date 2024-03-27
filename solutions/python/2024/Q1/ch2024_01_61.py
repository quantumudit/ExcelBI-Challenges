"""
This script provides functions to generate a square matrix and fetch its anti-diagonals.
"""


def generate_square_matrix(nrows: int) -> list[list]:
    """
    Given the number of rows, the function generates a square matrix starting from 1
    in the form of a nested list

    Args:
        nrows (int): The size of the matrix

    Returns:
        list[list]: a square matrix of size "nrows" in the form of a nested list
    """
    size = pow(nrows, 2)
    matrix = [[i for i in range(x, x + nrows)] for x in range(1, size + 1, nrows)]
    return matrix


def fetch_antidiagonals(matrix: list[list]) -> list[list]:
    """
    Fetches the anti-diagonals from a given square matrix represented as a nested list.

    Args:
        matrix (list[list]): The square matrix represented as a nested list.

    Returns:
        list[list]: A list containing all the anti-diagonals of the given
        square matrix. Each anti-diagonal is represented as a list of its elements.
    """
    anti_diags = []

    size = len(matrix)

    # Traverse the upper triangle
    anti_diags += [[matrix[i - j][j] for j in range(i + 1)] for i in range(size)]

    # Traverse lower triangle
    anti_diags += [
        [matrix[(size - j) + (i - 1)][j] for j in range(i, size)]
        for i in range(1, size)
    ]

    return anti_diags


if __name__ == "__main__":
    # Generate output for the given matrix sizes
    for mat_size in [2, 3, 4, 5]:
        data = generate_square_matrix(mat_size)
        for row in fetch_antidiagonals(data):
            print("\t".join(map(str, row)))
        print("\n===========\n")
