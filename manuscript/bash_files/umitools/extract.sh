#!/bin/sh

# This script forms the umitools pipeline for counting Illumina sequenced CELLO-seq reads.
# For more detail on the pipeline, please see https://umi-tools.readthedocs.io/en/latest/Single_cell_tutorial.html
# In this script, we extract barcodes and UMIs and add them to the read names.

fastq_r1=/path/to/fastq/file_r1.fastq
fastq_r2=/path/to/fastq/file_r2.fastq
whitelist=/path/to/whitelist.txt

umi_tools extract --stdin ${fastq_r2} --stdout ${fastq2_name}_extracted.fastq --read2-in ${fastq_r1} --read2-out ${fastq1_name}_extracted.fastq \
 --bc-pattern=\"(?P<cell_1>.{23,25})(?P<discard_1>AGTGGTATC){e<=2}(?P<umi_1>.{22})(?P<discard_2>ACTGGCCGTCGTTTTACATGGCGTAGCGGGTTCGAGCGCACCGC){e<=4}\" \
 --extract-method=regex --whitelist=${whitelist} --filter-cell-barcode --error-correct-cell --log2stderr
