#!/bin/bash

# Processess an HTML file (which should be the Cerner Model index) to add class names to table rows. 
# The `rows_of_interest_file` should be a plain text file containing the table names we care about.
# Allows users to apply JS or CSS filtering so that they only see the rows that are relevant to their project. 

# Change directory to the specified path
cd /Users/jamie/Downloads/CERNER\ MODEL/Merging

# Variables
html_file="source_tables.html"
output_file="modified_extracted_tables.html"
rows_of_interest_file="prsnL_id_tables_gt1000.txt"
new_class="prsnL_id_tables_gt1K"

# Read rows of interest into an array
rows_of_interest=()
while IFS= read -r line; do
    rows_of_interest+=("$line")
done < "$rows_of_interest_file"

# Convert array to a regex pattern
pattern=$(printf "|%s" "${rows_of_interest[@]}")
pattern=${pattern:1}  # Remove the leading '|'

# Use awk to modify the class names within <tr> tags containing any row of interest and save to a new file
awk -v pattern="$pattern" -v new_class="$new_class" -v output_file="$output_file" '
BEGIN {
    RS = "<tr";  # Set the record separator to <tr to handle each row as a record
    ORS = "";    # No output record separator to concatenate the records
}

{
    if ($0 ~ pattern) {
        tr_block = "<tr" $0
        # Extract the class attribute within the <tr> tag
        if (match(tr_block, /class="[^"]*"/)) {
            class_attr = substr(tr_block, RSTART + 7, RLENGTH - 8)
            
            # Add the new class to the class attribute
            modified_class_attr = class_attr " " new_class
            
            # Replace the original class attribute with the modified one
            sub(/class="[^"]*"/, "class=\"" modified_class_attr "\"", tr_block)
        }
        # Save the modified <tr> block
        print tr_block > output_file
    } else {
        # Save the unmodified blocks
        print "<tr" $0 > output_file
    }
}' "$html_file"

echo "Modification completed. The updated file is saved as $output_file."
