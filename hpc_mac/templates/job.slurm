#!/bin/bash
#SBATCH --job-name=cpu-test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:10:00
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
##SBATCH --account=YOUR_ACCOUNT
##SBATCH --partition=YOUR_PARTITION
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=YOUR_EMAIL

set -euo pipefail

echo "Job ID: ${SLURM_JOB_ID}"
echo "Job name: ${SLURM_JOB_NAME}"
echo "Node list: ${SLURM_NODELIST}"
echo "Submit directory: ${SLURM_SUBMIT_DIR}"
echo "Started: $(date)"

cd "${SLURM_SUBMIT_DIR}"

module purge
# module load anaconda3/2025.6
# conda activate YOUR_ENV

# Replace this with your real command.
hostname
python --version 2>/dev/null || true

echo "Finished: $(date)"
