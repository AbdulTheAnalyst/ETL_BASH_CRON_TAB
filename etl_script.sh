#!/bin/bash

# Define the URLs and file paths
CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"
RAW_DIR="raw"
TRANSFORMED_DIR="Transformed"
GOLD_DIR="Gold"
RAW_FILE="${RAW_DIR}/finance_data.csv"
TRANSFORMED_FILE="${TRANSFORMED_DIR}/2023_year_finance.csv"
GOLD_FILE="${GOLD_DIR}/2023_year_finance.csv"

# Create directories if they do not exist
mkdir -p "$RAW_DIR"
mkdir -p "$TRANSFORMED_DIR"
mkdir -p "$GOLD_DIR"

# Extract: Download the CSV file and save it into the raw folder
echo "Downloading CSV file..."
wget -O "$RAW_FILE" "$CSV_URL"

# Check if the file was successfully downloaded
if [ -f "$RAW_FILE" ]; then
    echo "File downloaded and saved to ${RAW_DIR}/"
else
    echo "Failed to download the file."
    exit 1
fi

# Transform: Rename the column and select specified columns
echo "Transforming data..."
# Rename "Variable_code" to "variable_code" in the header, then select the required columns
awk -F, 'NR==1 {
    for (i=1; i<=NF; i++) {
        if ($i == "Variable_code") $i = "variable_code";
        headers[$i] = i
    }
    print $headers["year"], $headers["Value"], $headers["Units"], $headers["variable_code"]
}
NR>1 {print $headers["year"], $headers["Value"], $headers["Units"], $headers["variable_code"]}' OFS=, "$RAW_FILE" > "$TRANSFORMED_FILE"

# Check if the transformed file was successfully created
if [ -f "$TRANSFORMED_FILE" ]; then
    echo "File transformed and saved to ${TRANSFORMED_DIR}/"
else
    echo "Failed to transform the file."
    exit 1
fi

# Load: Move the transformed file to the Gold directory
echo "Loading data into Gold directory..."
cp "$TRANSFORMED_FILE" "$GOLD_FILE"

# Check if the file was successfully moved to the Gold directory
if [ -f "$GOLD_FILE" ]; then
    echo "File successfully loaded into ${GOLD_DIR}/"
else
    echo "Failed to load the file into the Gold directory."
    exit 1
fi

echo "ETL process completed successfully."

