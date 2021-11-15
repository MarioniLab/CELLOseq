#!/bin/sh

# This script forms the umitools pipeline for counting Illumina sequenced CELLO-seq reads.
# For more detail on the pipeline, please see https://umi-tools.readthedocs.io/en/latest/Single_cell_tutorial.html
# In this script, we count UMIs per gene per cell.

bam=/path/to/bam/file.bam

umi_tools count --per-gene --gene-tag=XT --assigned-status-tag=XS --per-cell --edit-distance-threshold=2 --wide-format-cell-counts -I ${bam} -S ${bam%bam}counts.tsv
