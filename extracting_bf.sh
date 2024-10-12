#!/bin/bash

# Create the CSV files
output_csv="binding_affinities.csv"
first_pose_csv="first_pose_affinities.csv"

# Headers for the CSV files
echo "Ligand,Binding_Affinity" > $output_csv
echo "Ligand,First_Pose_Affinity" > $first_pose_csv

# Loop through all .log files in all subdirectories
find . -name "*.log" | while read logfile; do
  # Extract the ligand name (before the first underscore)
  ligand=$(basename "$logfile" | cut -d'_' -f1)
  
  # Extract all binding affinities from the log file
  affinities=$(grep -oP '^\s*\d+\s+\K-\d+\.\d+' "$logfile")
  
  # Extract the first pose's binding affinity (first line of affinities)
  first_affinity=$(echo "$affinities" | head -n 1)
  
  # Save all binding affinities to the CSV
  echo "$affinities" | while read affinity; do
    echo "$ligand,$affinity" >> $output_csv
  done

  # Save only the first pose's binding affinity to the other CSV
  echo "$ligand,$first_affinity" >> $first_pose_csv
done

echo "Extraction completed. CSV files saved as $output_csv and $first_pose_csv."
