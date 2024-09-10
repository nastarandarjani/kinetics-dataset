#!/bin/bash

# Define the base directory where the CSV files and folders are located
base_dir="."

# Function to read the CSV into an associative array
declare -A id_to_label

read_csv_to_array() {
    local csv_file="$1"
    while IFS=, read -r label youtube_id time_start time_end csv_split is_cc; do
        id_to_label["$youtube_id"]="$label"
    done < "$csv_file"
}

# Process each of train, val, and test datasets
for split in train val test; do
    # Paths to the original CSV and the directory containing the .mp4 files
    csv_file="$base_dir/$split.csv"
    mp4_dir="$base_dir/$split"
    output_csv="$base_dir/${split}_output.csv"
    
    # Read the CSV data into the associative array
    id_to_label=()
    read_csv_to_array "$csv_file"
    
    # Initialize the counter for the inner loop
    counter=1
    
    # Loop through each .mp4 file in the directory
    for mp4_file in "$mp4_dir"/*.mp4; do
        # Increment the counter
        ((counter++))
        
        # Extract the filename without the path
        mp4_name=$(basename "$mp4_file")
        
        # Extract the youtube_id by removing everything after the first underscore
        youtube_id=$(echo "$mp4_name" | sed 's/\(.*\)_.\{6\}_.\{6\}\.mp4/\1/')
        
        # Get the corresponding label from the associative array
        label="${id_to_label[$youtube_id]}"
        
        # Append the name and label to the output CSV
        echo "$mp4_name,$label" >> "$output_csv"
        
        # Format the counter as a 7-digit number with leading zeros
        formatted_counter=$(printf "%06d" "$counter")
    
        # Echo the current split, mp4_name, and counter
        echo "$formatted_counter: $split - $mp4_name"
    done
done