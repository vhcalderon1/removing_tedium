# Slurm Templates

Copy one of these files to the project root, rename it if useful, and edit the command section.

```bash
cp hpc_mac/templates/job.slurm job.slurm
nano job.slurm
```

## Which Template to Use

- `job.slurm`: one small CPU job; best first test
- `job_gpu.slurm`: one GPU job
- `job_array.slurm`: many independent tasks from `tasks.txt`
- `job_chain.slurm`: long checkpoint/restart jobs using `--dependency=singleton`

## Editing Rules

- Keep resource requests small until the test job works.
- Uncomment and set `--account` or `--partition` only if your center requires them.
- Load all modules inside the Slurm script.
- Write output into a predictable folder such as `results/`, `output/`, `outputs/`, or `figures/`.
- Keep `--output` and `--error` names unique with `%j`, `%A`, or `%a`.

## Submitting

After editing `job.slurm`:

```bash
bash hpc_mac/bin/hpc-submit
```

To submit a different script:

```bash
bash hpc_mac/bin/hpc-submit hpc_mac/templates/job_gpu.slurm
```

For long chained jobs, submit the same job several times:

```bash
sbatch job_chain.slurm
sbatch job_chain.slurm
sbatch job_chain.slurm
```

Each pending job waits for the previous job with the same name because of `--dependency=singleton`.
