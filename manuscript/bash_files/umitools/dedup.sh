#!/bin/sh

# This script forms the umitools pipeline for counting Illumina sequenced CELLO-seq reads.
# For more detail on the pipeline, please see https://umi-tools.readthedocs.io/en/latest/Single_cell_tutorial.html
# This is an optional step for producing deduplicated BAM.

bam=/path/to/bam/file.bam

umi_tools dedup --per-gene --gene-tag=XT --assigned-status-tag=XS --per-cell --edit-distance-threshold=2 \
--stdin=${bam} --out-sam --log=${bam%bam}log.txt > ${bam%bam}deduplicated.bam
