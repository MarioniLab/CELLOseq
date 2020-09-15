#!/bin/sh

# This script forms the umitools pipeline for counting Illumina sequenced CELLO-seq reads.
# For more detail on the pipeline, please see https://umi-tools.readthedocs.io/en/latest/Single_cell_tutorial.html
# In this script, we identify the correct cell barcode.

fastq=/path/to/fastq/file_r2.fq # Read 2 contains the adapter sequence
output=/path/to/output

umi_tools whitelist --stdin ${fastq} \
--bc-pattern=\"(?P<cell_1>.{23,25})(?P<discard_1>AGTGGTATC){e<=2}(?P<umi_1>.{21,23})(?P<discard_2>ACTGGCCGTCGTTTTACATGGCGTAGCGGGTTCGAGCGCACCGC){s<=4}\" \
--extract-method=regex --set-cell-number=6 --error-correct-threshold=4 --log2stderr > ${output}/whitelist.txt
