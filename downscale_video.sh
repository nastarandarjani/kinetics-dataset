SRC_DIR="/home/nasi14/scratch/k400/downsampled/train"
TARGET_DIR="/home/nasi14/scratch/k400/downsampled/train/train"

mkdir -p "$TARGET_DIR"

# Function to process each video
process_video() {
    video="$1"
    filename=$(basename "$video")
    output="/home/nasi14/scratch/k400/downsampled/train/train/$filename"

    echo "----"
    # Run ffmpeg to resize and save the output
    ffmpeg -y -i "$video" -vf "scale=-2:256" -c:a copy "$output" > /dev/null 2>&1 && rm -v "$video"
}

export -f process_video  # Export the function for use in subshells

# Find and process videos in parallel with xargs, limited to 8 processes
find "$SRC_DIR" -maxdepth 1 -type f -print0 | xargs -0 -n 1 -P 35 bash -c 'process_video "$@"' _
