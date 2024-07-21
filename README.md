# Cerner Documentation shell scripts
Scripts to aid the annotation of the Cerner Model HTML documentation

An extremely niche issue, but helpful for about a few dozen people on the planet.

These scripts assume you have access to the Cerner Model documentation (available from UCern).

# Cerner model merger
Loops through a folder of Cerner table HTML files and merge into one
Assumes that the files follow the naming convention of dm_*.html as in the 2018.x models
Make sure not to output files that match this pattern, or you'll recursively add tables with each run

# Cerner row of interest marker
Processess an HTML file (which should be the Cerner Model index) to add class names to table rows. The `rows_of_interest_file` should be a plain text file containing the table names we care about.
Allows users to apply JS or CSS filtering so that they only see the rows that are relevant to their project. 