"""
This script generates a standard data science project template
"""

import logging
import os
from datetime import datetime

logging.basicConfig(level=logging.INFO)

# Dynamic directory generation
primary_dirs = ["challenges", "data", "solutions/python", "solutions/powerquery"]

this_month = datetime.now().month
this_year = datetime.now().year
this_quarter = (this_month - 1) // 3 + 1

generated_file_names = []

for p_dir in primary_dirs:
    for year in range(2022, this_year + 1):
        for qtr in range(1, 5):
            if year == 2022 and qtr < 3:
                pass
            elif year == this_year and qtr > this_quarter:
                pass
            else:
                file_name = f"{p_dir}/{year}/Q{qtr}/.gitkeep"
                generated_file_names.append(file_name)

other_files_names = [
    "resources/.gitkeep",
    "requirements.txt",
    ".gitignore",
    "LICENSE",
    "README.md",
    "todo.md",
]

list_of_files = generated_file_names + other_files_names

# Iterate over file and create them
for file_path in list_of_files:
    file_path = os.path.normpath(file_path)
    file_dir, file_name = os.path.split(file_path)

    # Create directory if not exist
    if file_dir != "":
        os.makedirs(file_dir, exist_ok=True)
        logging.info("Creating directory: %s for the file %s", file_dir, file_name)

for file_path in other_files_names:
    file_path = os.path.normpath(file_path)
    file_dir, file_name = os.path.split(file_path)
    # Create file if not exists or if the file is empty
    if (
        file_dir == "resources"
        and len([content for content in os.listdir(file_dir)]) != 0
    ):
        pass
    else:
        if (not os.path.exists(file_path)) or (os.path.getsize(file_path) == 0):
            with open(file_path, "w", encoding="utf-8") as f:
                logging.info("Creating empty files: %s", file_path)

        # Ignore if the non-empty file already exists
        else:
            logging.info("%s already exists", file_name)

for file_path in generated_file_names:
    file_path = os.path.normpath(file_path)
    file_dir, file_name = os.path.split(file_path)
    # Create file if the parent folder is empty

    if len([content for content in os.listdir(file_dir)]) == 0:
        with open(file_path, "w", encoding="utf-8") as f:
            logging.info("Creating empty files: %s", file_path)
    # Ignore if the non-empty file already exists
    else:
        logging.info("Content exists in the folder %s", file_dir)
