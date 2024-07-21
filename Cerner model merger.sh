#!/bin/zsh

# Loop through a folder of Cerner table HTML files and merge into one
# Assumes that the files follow the naming convention of dm_*.html as in the 2018.x models
# Make sure not to output files that match this pattern, or you'll recursively add tables with each run

cd /Users/jamie/Downloads/CERNER\ MODEL/Merging  
# Create or clear the output file
> extracted_tables.html

# Prepend header.html to the output file
cat header.html >> extracted_tables.html

# Loop through all HTML files
for file in dm_*.html; do
    # Extract the filename without the extension
    filename=$(basename "$file" .html)
    # Remove "DM_" and extract the part after the underscore
    anchor=$(echo "$filename" | cut -d'_' -f2)
    # Convert the anchor to uppercase
    anchor=$(echo "$anchor" | tr '[:lower:]' '[:upper:]')
    # Echo an in-document HTML anchor tag based on the extracted part and append to the output file
    echo "<a class = \"indexer\" id=\"$anchor\">$anchor</a>" >> extracted_tables.html
    # Extract tables and append to the output file
    perl -0777 -ne 'print "$1\n" while /(<table id="table-list">.*?<\/table>)/sg' "$file" >> extracted_tables.html
done

# Append footer.html to the output file
cat footer.html >> extracted_tables.html
