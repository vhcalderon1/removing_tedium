# hpc_mac

Portable Mac-to-HPC starter files for projects that need to be copied to a cluster, submitted with Slurm, monitored, and brought back to the laptop.

This folder was built from the workflow ideas already present in this repository:

- minimize repeated Duo prompts with SSH keys, host nicknames, and SSH multiplexing
- keep project submission repeatable with a standard `job.slurm`
- use short local commands for sync, submit, queue status, and result download
- start with small test jobs before scaling to larger CPU, GPU, array, or chained jobs
- keep cluster-specific values in one editable file instead of hard-coding them in scripts

The files are intentionally generic. Copy `hpc_mac/` into another project and edit only `hpc.env`.

## Contents

- `hpc.env.example`: project-specific settings to copy to `hpc.env`
- `ssh_config.example`: Mac `~/.ssh/config` patterns for host aliases, proxy jumps, and multiplexing
- `hpc_aliases.sh`: optional shell functions for your Mac terminal
- `rsync_excludes.txt`: default files to avoid transferring to the cluster
- `bin/`: local helper scripts for setup, sync, submit, status, remote shell, and result fetch
- `templates/`: Slurm templates for CPU, GPU, array, and chained jobs
- `CHECKLIST.md`: quick review before submitting work

## Quick Start

From the root of any project:

```bash
# 1. Paste or copy this folder into the project.
# 2. Create a local config file.
bash hpc_mac/bin/hpc-setup

# 3. Edit hpc.env for your account, cluster, and remote project path.
nano hpc.env

# 4. Copy one Slurm template into the project root and edit the command section.
cp hpc_mac/templates/job.slurm job.slurm
nano job.slurm

# 5. Send the project to the cluster.
bash hpc_mac/bin/hpc-sync-to-cluster

# 6. Submit the job from your Mac.
bash hpc_mac/bin/hpc-submit

# 7. Check status.
bash hpc_mac/bin/hpc-status

# 8. Fetch common result files when the job finishes.
bash hpc_mac/bin/hpc-fetch-results
```

If you source the aliases:

```bash
source hpc_mac/hpc_aliases.sh
hpcsetup
hpcsync
hpcsubmit
hpcstatus
hpcfetch
```

## One-Time Mac Setup

Create SSH keys if you do not already have them:

```bash
ls -l ~/.ssh
ssh-keygen -t ed25519
```

Copy your public key to the cluster:

```bash
ssh-copy-id YOUR_NETID@YOUR_CLUSTER_LOGIN_HOST
```

Then adapt `ssh_config.example` into `~/.ssh/config`. Use a short `Host` alias, for example `della`, `tiger`, `adroit`, or `myhpc`. The scripts in this folder use `HPC_HOST` from `hpc.env`, so that value can be either a short alias or a full host name.

## Typical Project Flow

1. Work locally on your Mac.
2. Run `hpcsync` or `bash hpc_mac/bin/hpc-sync-to-cluster`.
3. Run a short test job first, for example 5-10 minutes with small input.
4. Inspect `slurm-<jobid>.out` and `slurm-<jobid>.err` on the cluster.
5. Increase time, memory, CPUs, GPUs, or array size only after the small job works.
6. Fetch results with `hpcfetch` or use `hpcshell` to inspect the remote directory.

## Notes for Non-Slurm Centers

These files assume Slurm commands such as `sbatch`, `squeue`, `sacct`, and `scancel`. If your HPC center uses PBS, LSF, or another scheduler, keep the sync scripts and replace the `templates/*.slurm` files plus the scheduler commands in `bin/hpc-submit` and `bin/hpc-status`.

## Safety Defaults

The sync script does not delete files on the cluster by default. To mirror deletions from your Mac to the cluster, set this in `hpc.env` only when you are sure:

```bash
HPC_RSYNC_DELETE=1
```

Keep private keys, tokens, raw credentials, and large generated outputs out of the transfer by adding them to `rsync_excludes.txt`.
