#!/bin/sh

# This script is designed for basecalling nanopore reads using guppy basecaller.

fast5_file=/path/to/fast5/files
fastq_output=/path/to/fastq/output

guppy_basecaller -i ${fast5_file} -s ${fastq_output} --num_callers 16 --chunks_per_runner 96 \
-c dna_r9.4.1_450bps_hac.cfg -x auto --calib_detect