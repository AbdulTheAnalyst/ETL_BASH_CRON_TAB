#!/bin/bash

# Set the source and target directories
SOURCE_DIR="/source_folder"
TARGET_DIR="/json_and_CSV"

# Create the target directory if it doesn't exist
if [ ! -d "$TARGET_DIR" ]; then
  echo "Creating target directory: $TARGET_DIR"
  mkdir -p "$TARGET_DIR"
fi

# Move all CSV and JSON files from the source folder to the target folder
echo "Moving CSV and JSON files..."
mv "$SOURCE_DIR"/*.csv "$SOURCE_DIR"/*.json "$TARGET_DIR" 2>/dev/null

# Check if files were successfully moved
if [ $? -eq 0 ]; then
  echo "Files moved successfully."
else
  echo "No CSV or JSON files found to move."
fi


