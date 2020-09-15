## CELLO-seq Sarlacc pipeline

This folder contains `Rmarkdown` files and scripts which forms the CELLO-seq Sarlacc data processing pipeline.
This pipeline is based primarily on the R `Sarlacc` package ([GitHub](https://github.com/MarioniLab/Sarlacc)), with modifications specific to CELLO-seq protocol. 
For more detailed explanation of the pipeline, please check out CELLO-seq manuscript.

The workflow for the data processing pipeline is as follow:

![Alt CELLO-seq Sarlacc pipeline workflow](pipeline_workflow.png?raw=true "CELLO-seq Sarlacc pipeline workflow")

We have also included a few helper scripts:

- `filter_read_lengths.sh`: This script is designed to filter for reads longer than 20 Kb due to issue with Biostring package.
- `build_minimap_index.sh`: This script is designed for building minimap2 index.
- `dispatcher_*.R`: These scripts are designed to create sample specific Rmd files based on the template Rmd files.
- `tuning.Rmd`: This script is designed to determine the optimal alignment parameters used by Sarlacc.
