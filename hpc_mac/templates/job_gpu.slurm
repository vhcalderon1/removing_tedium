#!/bin/bash
#SBATCH --job-name=gpu-test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --gres=gpu:1
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
##SBATCH --account=YOUR_ACCOUNT
##SBATCH --partition=YOUR_GPU_PARTITION
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=YOUR_EMAIL

set -euo pipefail

echo "Job ID: ${SLURM_JOB_ID}"
echo "Node list: ${SLURM_NODELIST}"
echo "CUDA visible devices: ${CUDA_VISIBLE_DEVICES:-not set}"
echo "Started: $(date)"

cd "${SLURM_SUBMIT_DIR}"

module purge
# module load anaconda3/2025.6
# module load cudatoolkit
# conda activate YOUR_GPU_ENV

nvidia-smi || true

# Replace this with your real GPU command.
# python train.py --epochs 1 --device cuda

echo "Finished: $(date)"
