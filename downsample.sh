#!/bin/bash
#SBATCH --job-name=downscale_videos   # Job name
#SBATCH --nodes=1                     # Number of nodes
#SBATCH --ntasks=1                    # Number of tasks (1 per node)
#SBATCH --cpus-per-task=16            # Number of CPU cores per task, matching n_jobs=16
#SBATCH --mem=8G                     # Memory per node, adjusted to handle video processing
#SBATCH --time=00:10:00               # Time limit hrs:min:sec, extended to 72 hours
#SBATCH --mail-user=nastaran14darjani@gmail.com
#SBATCH --mail-type=ALL

cd $project/kinetics-dataset
# module load ffmpeg

source ~/venv/bin/activate

# Run your Python script
python downscale_video.py