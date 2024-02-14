#!/bin/bash

source config

echo 'comparing for database named: '${DB}

# Define filenames
INPUT_CSV="/data/counts_to_compare_against_for_v3.csv"
#PREVIOUS_RESULTS_MD="/data/${DB}_table_counts_$(date +%Y%m%d)_md.md"
PREVIOUS_RESULTS_MD="/data/${DB}_table_counts_20230822_md.md"
OUTPUT_FILE="/data/comparison_results_$(date +%Y%m%d)_most_md.md"
TEMP_FILE=$(mktemp)

# Read the previously generated markdown file line by line, skipping the header lines
tail -n +3 "$PREVIOUS_RESULTS_MD" | while read -r line
do
  # Extract the schema, table name, and count from the line
  schema=$(echo $line | awk -F '|' '{gsub(/ /, "", $2); print $2}')
  schema=${schema// /} # Remove spaces if any
  table_name=$(echo $line | awk -F '|' '{gsub(/ /, "", $3); print $3}')
  table_name=${table_name// /} # Remove spaces if any
  count_results=$(echo $line | awk -F '|' '{gsub(/ /, "", $4); print $4}')

  # Find the corresponding line in the CSV file using the schema and table name
  IFS=$',' read -r csv_schema csv_table compare_count source < <(grep -P "^$schema,$table_name," "$INPUT_CSV")

  # Calculate the difference if there's a match
  if [ -n "$csv_schema" ]; then
    diff=$((count_results - compare_count))
  else
    compare_count="NA"
    diff="NA"
    source="NA"
  fi

  # Write the results to the temporary file
  echo "$schema,$table_name,$count_results,$compare_count,$diff,$source" >> $TEMP_FILE
done

# Write the markdown header to the output file
echo "| schema | table name | count(*) results | compare_against count | diff | source |" > $OUTPUT_FILE
echo "|--------|------------|------------------|----------------------|------|--------|" >> $OUTPUT_FILE

# Sort the temporary file by diff (5th field), schema (1st field), and table name (2nd field), then convert to markdown
sort -t',' -k5,5n -k1,1 -k2,2 $TEMP_FILE | awk -F',' '{printf("| %s | %s | %s | %s | %s | %s |\n", $1, $2, $3, $4, $5, $6)}' >> $OUTPUT_FILE

# Clean up the temporary file
rm $TEMP_FILE

echo "Comparison markdown file has been created at $OUTPUT_FILE"