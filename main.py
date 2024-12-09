import csv
import os
import re
from typing import Any

# Define the root folder to start traversal
ROOT_FOLDER = "./"
YEARS: list[int] = [2022, 2023, 2024, 2025]
CHALLENGE_NAME_CSV: str = os.path.normpath(
    "./resources/challenge_name_reference.csv"
)

# Step 1: Read Challenge Names from CSV
challenge_name_map: dict[str, str] = {}
with open(CHALLENGE_NAME_CSV, mode="r", encoding="utf-8") as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        chall_id: str | Any = row["ChallengeID"].strip()
        chall_name: str | Any = row["ChallengeName"].strip()
        challenge_name_map[chall_id] = chall_name if chall_name else "Challenge"

# Initialize a dictionary to store file paths
files_dict: dict = {}

# Traverse through folders and subfolders
for year in YEARS:
    year_folder: str = os.path.normpath(os.path.join(ROOT_FOLDER, str(year)))
    for dirpath, _, filenames in os.walk(year_folder):
        for file in filenames:
            # Match file patterns for challenge-related files
            match: re.Match[str] | None = re.match(
                r"(\d{4}_\d{2}_\d{2})_(.*)", file
            )
            if match:
                challenge_id: str | Any = match.group(1)
                file_type: str | Any = match.group(2)

                # Initialize nested dictionary for the challenge ID
                if challenge_id not in files_dict:
                    files_dict[challenge_id] = {}
                files_dict[challenge_id][file_type] = os.path.normpath(
                    os.path.join(dirpath, file)
                ).replace("\\", "/")

# Create Markdown table content
markdown_rows: list[str] = [
    "| Challenge ID | Challenge | Data | Solution Script - PowerQuery | Solution Script - Python |",
    "|--------------|-----------|------|-----------------------------|--------------------------|",
]

# Fill table rows
for challenge_id, file_paths in sorted(files_dict.items()):
    challenge_name: str = challenge_name_map.get(challenge_id, "Challenge")
    challenge_path: str = file_paths.get(
        "challenge.png", file_paths.get("challenge.jpg", "")
    )
    data_path: str = file_paths.get("data.csv", "")
    pq_path: str = file_paths.get("solution.pq", "")
    py_path: str = file_paths.get("solution.py", "")

    # Replace "NA" with plain text in Markdown if the file is missing
    challenge_cell: str = (
        f"[{challenge_name}]({challenge_path})"
        if challenge_path != ""
        else "NA"
    )
    data_cell: str = f"[Data]({data_path})" if data_path != "" else "NA"
    pq_cell: str = f"[PowerQuery Solution]({pq_path})" if pq_path != "" else "NA"
    py_cell: str = f"[Python Solution]({py_path})" if py_path != "" else "NA"

    markdown_rows.append(
        f"| {challenge_id} | {challenge_cell} | {data_cell} | {pq_cell} | {py_cell} |"
    )

# Write to a Markdown file
OUTPUT_FILE = "challenge_table.md"
with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write("\n".join(markdown_rows))

print(f"Markdown table saved to {OUTPUT_FILE}")
