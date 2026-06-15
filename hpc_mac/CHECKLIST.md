# HPC Submission Checklist

Use this before submitting a job from a Mac or from the cluster login node.

## Local Mac

- `hpc.env` exists in the project root and has the correct `HPC_HOST`, `HPC_USER`, and `HPC_REMOTE_ROOT`.
- `ssh HPC_HOST` works without repeatedly asking for passwords.
- `bash hpc_mac/bin/hpc-sync-to-cluster` completes without transferring private keys, virtual environments, or large local outputs.
- `rsync_excludes.txt` includes any project-specific secrets, caches, and generated data that should not go to the cluster.

## Slurm Script

- The job name is short and recognizable.
- Wall time is conservative for testing, then increased for production.
- CPU, memory, GPU, partition, and account directives match the cluster policy.
- The script loads modules inside the Slurm script, not only in an interactive shell.
- The command section uses paths relative to the project directory or documented absolute paths.
- Output and error files are named with `%j` so each job gets separate logs.

## First Test

- Run with a tiny input or a short wall time first.
- Check `slurm-<jobid>.out` and `slurm-<jobid>.err`.
- Confirm the program can find input files after syncing.
- Confirm output lands in `results/`, `output/`, `outputs/`, `figures/`, or another directory you plan to fetch.

## Scaling Up

- Use job arrays for many independent tasks.
- Use checkpoint/restart or `--dependency=singleton` for jobs longer than the wall-time limit.
- Watch memory and GPU utilization before requesting larger resources.
- Cancel failed or runaway jobs quickly with `hpccancel` or `scancel <jobid>`.

## After Completion

- Run `hpcstatus` or inspect `sacct` for final state and exit code.
- Fetch results with `hpcfetch`; use `hpcfetch --all` only when the remote project is not too large.
- Record working Slurm settings in the project README or lab notebook.
