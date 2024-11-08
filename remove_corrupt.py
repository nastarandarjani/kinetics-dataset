import os
import sys
from concurrent.futures import ProcessPoolExecutor
from decord import VideoReader


def check_video(video_path):
    """Check if a video file is corrupted."""
    try:
        vr = VideoReader(video_path)
        # If the video loads without exceptions, it's likely not corrupted
        _ = vr[0]  # Try to read the first frame
        return True
    except Exception as e:
        print(f"Corrupted file detected: {video_path} - {e}")
        if "temporarily unavailable" not in str(e):
            return False
        else:
            return True

def remove_corrupt_videos(video_dir):
    """Remove corrupted video files from the specified directory."""
    video_files = [f for f in os.listdir(video_dir) if f.endswith(".mp4")]
    corrupted_files = []

    with ProcessPoolExecutor() as executor:
        results = list(
            executor.map(check_video, [os.path.join(video_dir, f) for f in video_files])
        )

    for video_file, is_valid in zip(video_files, results):
        if not is_valid:
            corrupted_files.append(video_file)
            os.remove(os.path.join(video_dir, video_file))
            print(f"Removed corrupted video: {video_file}")

    print(f"Removed {len(corrupted_files)} corrupted video files.")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python remove_corrupt.py <video_dir>")
        sys.exit(1)

    video_dir = sys.argv[1]
    remove_corrupt_videos(video_dir)
