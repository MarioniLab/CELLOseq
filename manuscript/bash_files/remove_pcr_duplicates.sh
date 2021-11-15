#!/bin/sh

# This script is designed for removing PCR duplicates using MarkDuplicates from GATK.

bam_files=$(ls /path/to/aligned/file/*.sortedByCoord.out.bam)
output_folder=/path/to/output/folder

for bam in ${bam_files}; do
  bam_name=$(basename ${bam} | sed "s/_Aligned.sortedByCoord.out.bam//g")
  out_prefix=${output_folder}/${bam_name}.sortedByCoord.out.dedup

  gatk MarkDuplicates -I ${bam} -O ${out_prefix}.bam -M ${out_prefix}.metrics.txt --REMOVE_DUPLICATES --ASSUME_SORT_ORDER=coordinate
done
