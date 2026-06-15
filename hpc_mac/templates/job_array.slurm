#!/bin/bash
#SBATCH --job-name=array-test
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=00:10:00
#SBATCH --array=0-2
#SBATCH --output=slurm-%A_%a.out
#SBATCH --error=slurm-%A_%a.err
##SBATCH --account=YOUR_ACCOUNT
##SBATCH --partition=YOUR_PARTITION

set -euo pipefail

cd "${SLURM_SUBMIT_DIR}"

TASK_FILE="${TASK_FILE:-hpc_mac/templates/tasks.txt}"
TASK_INDEX=$((SLURM_ARRAY_TASK_ID + 1))
TASK_CMD="$(sed -n "${TASK_INDEX}p" "${TASK_FILE}")"

if [[ -z "${TASK_CMD}" ]]; then
  echo "No command found for array index ${SLURM_ARRAY_TASK_ID} in ${TASK_FILE}" >&2
  exit 1
fi

echo "Job ID: ${SLURM_JOB_ID}"
echo "Array task ID: ${SLURM_ARRAY_TASK_ID}"
echo "Command: ${TASK_CMD}"
echo "Started: $(date)"

module purge
# module load anaconda3/2025.6
# conda activate YOUR_ENV

# Only use a task file that you control.
bash -lc "${TASK_CMD}"

echo "Finished: $(date)"
