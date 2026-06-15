#!/usr/bin/env bash

set -euo pipefail

HPC_BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
HPC_PROJECT_DIR="$(cd "${HPC_BUNDLE_DIR}/.." && pwd -P)"
HPC_ENV_FILE="${HPC_ENV_FILE:-${HPC_PROJECT_DIR}/hpc.env}"

hpc_die() {
  echo "hpc_mac: $*" >&2
  exit 1
}

hpc_quote() {
  printf "%q" "$1"
}

if [[ ! -f "${HPC_ENV_FILE}" ]]; then
  hpc_die "missing ${HPC_ENV_FILE}. Run: bash hpc_mac/bin/hpc-setup"
fi

set +u
# shellcheck disable=SC1090
source "${HPC_ENV_FILE}"
set -u

HPC_HOST="${HPC_HOST:-}"
HPC_USER="${HPC_USER:-}"
HPC_REMOTE_ROOT="${HPC_REMOTE_ROOT:-}"
HPC_PROJECT_NAME="${HPC_PROJECT_NAME:-$(basename "${HPC_PROJECT_DIR}")}"
HPC_REMOTE_DIR="${HPC_REMOTE_DIR:-}"
HPC_SLURM_SCRIPT="${HPC_SLURM_SCRIPT:-job.slurm}"
HPC_EXCLUDES="${HPC_EXCLUDES:-hpc_mac/rsync_excludes.txt}"
HPC_RSYNC_DELETE="${HPC_RSYNC_DELETE:-0}"
HPC_LOCAL_RESULTS_DIR="${HPC_LOCAL_RESULTS_DIR:-hpc_results}"

[[ -n "${HPC_HOST}" ]] || hpc_die "set HPC_HOST in ${HPC_ENV_FILE}"
[[ -n "${HPC_REMOTE_ROOT}" ]] || hpc_die "set HPC_REMOTE_ROOT in ${HPC_ENV_FILE}"
[[ -n "${HPC_PROJECT_NAME}" ]] || hpc_die "set HPC_PROJECT_NAME or use a named project directory"

if [[ -z "${HPC_REMOTE_DIR}" ]]; then
  HPC_REMOTE_DIR="${HPC_REMOTE_ROOT%/}/${HPC_PROJECT_NAME}"
fi

if [[ "${HPC_EXCLUDES}" != /* ]]; then
  HPC_EXCLUDES="${HPC_PROJECT_DIR}/${HPC_EXCLUDES}"
fi

if [[ "${HPC_LOCAL_RESULTS_DIR}" != /* ]]; then
  HPC_LOCAL_RESULTS_DIR="${HPC_PROJECT_DIR}/${HPC_LOCAL_RESULTS_DIR}"
fi

HPC_SSH_TARGET="${HPC_HOST}"
if [[ -n "${HPC_USER}" && "${HPC_HOST}" != *"@"* ]]; then
  HPC_SSH_TARGET="${HPC_USER}@${HPC_HOST}"
fi
