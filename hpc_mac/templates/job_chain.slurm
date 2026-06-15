#!/bin/bash
#SBATCH --job-name=chain-test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:30:00
#SBATCH --dependency=singleton
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
##SBATCH --account=YOUR_ACCOUNT
##SBATCH --partition=YOUR_PARTITION
##SBATCH --mail-type=END,FAIL
##SBATCH --mail-user=YOUR_EMAIL

set -euo pipefail

cd "${SLURM_SUBMIT_DIR}"

CHECKPOINT_DIR="${CHECKPOINT_DIR:-checkpoints}"
mkdir -p "${CHECKPOINT_DIR}"

LATEST_CHECKPOINT="$(ls -t "${CHECKPOINT_DIR}"/checkpoint-* 2>/dev/null | head -n 1 || true)"

echo "Job ID: ${SLURM_JOB_ID}"
echo "Latest checkpoint: ${LATEST_CHECKPOINT:-none}"
echo "Started: $(date)"

module purge
# module load anaconda3/2025.6
# conda activate YOUR_ENV

if [[ -n "${LATEST_CHECKPOINT}" ]]; then
  echo "Restarting from ${LATEST_CHECKPOINT}"
  # python run.py --restart "${LATEST_CHECKPOINT}" --checkpoint-dir "${CHECKPOINT_DIR}"
else
  echo "Starting new run"
  # python run.py --checkpoint-dir "${CHECKPOINT_DIR}"
fi

# Replace the commented commands above with an application that writes a
# checkpoint before the wall-time limit. Submit this same script multiple times:
#   sbatch job_chain.slurm
#   sbatch job_chain.slurm
#   sbatch job_chain.slurm
# Slurm will run one chain-test job at a time because of --dependency=singleton.

echo "Finished: $(date)"
