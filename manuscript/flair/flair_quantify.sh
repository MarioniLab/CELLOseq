#!/bin/sh

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we quantify FLAIR isoform usage across samples using minimap2.

collapsed_isoform_file=/path/to/combined/collapsed.isoforms.fa
manifest_file=/path/to/reads_manifest.tsv
output=/path/to/output

/flair/flair.py quantify -r ${manifest_file} -i ${collapsed_isoform_file} \
--salmon /path/to/salmon \
--output ${output}/flair_quantify