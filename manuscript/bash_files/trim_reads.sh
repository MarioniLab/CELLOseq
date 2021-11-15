#!/bin/sh

# This script is designed for trimming Illumina reads using Trim Galore!.

fastq_files=$(ls /path/to/fastq/*.filtered.r_1.fq.gz)
output_folder=/path/to/output_folder

for fastq in ${fastq_files}; do
  r1_prefix=$(echo $fastq | sed "s/.r_1.fq.gz//")
  trim_galore --fastqc --nextera --paired --length 50 --clip_R1 25 --clip_R2 25 \
  -o ${output_folder}/trim_galore_output/ -q 20 ${r1_prefix}.r_1.fq.gz ${r1_prefix}.r_2.fq.gz
done 
