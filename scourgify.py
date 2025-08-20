# 2023-10-9
# scourgify.py
# Farah Noor
# 
# Purpose:

import sys
import csv

# Check length and type of file
if len(sys.argv) == 3:
  if sys.argv[1].endswith(".csv"):

    # Use try and except to catch FileNotFoundError
    try:

      # Open existing file and read it
      with open(sys.argv[1]) as file:
        reader = csv.DictReader(file)

        # Create and open a new file
        with open(sys.argv[2], "w") as file2:

          # Create fieldnames for file and write them, making them as header of file
          fieldnames = ["first", "last", "house"]
          writer = csv.DictWriter(file2, fieldnames = fieldnames)
          writer.writeheader()

          # For each row in existing file, replace key name with first
          for row in reader:
            row["first"] = row.pop("name")

            # Split key first into first and last variables, assigning them back to the row
            lastname, firstname = row["first"].split(", ")
            row["first"] = firstname
            row["last"] = lastname

            # Write the changes in row in new file
            writer.writerow(row)
    except FileNotFoundError:
      sys.exit("Could not read")
  else:
    sys.exit("Not a CSV file" + sys.argv[1])
elif len(sys.argv) > 3:
  sys.exit("Too many command-line arguments")
else:
  sys.exit("Too few command-line arguments")
