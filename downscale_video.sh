#!/bin/bash

SRC_DIR="$SLURM_TMPDIR/data/train/raw"
TARGET_DIR="$SLURM_TMPDIR/data/train/downsampled"

mkdir -p "$TARGET_DIR"


# Process each video in the background
for video in "$SRC_DIR"/*; do
    filename=$(basename "$video")
    output="$TARGET_DIR/$filename"

    # Run ffmpeg in the background
    ffmpeg -i "$video" -vf "scale=-2:256" -c:a copy "$output" &
    
    # Limit number of background jobs to 40
    if (( $(jobs -r | wc -l) >= 39 )); then
        wait -n
    fi
done

# Wait for all background jobs to complete
wait


echo "Resizing complete. Check the target folder: $TARGET_DIR"
