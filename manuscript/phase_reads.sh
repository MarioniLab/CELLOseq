#!/bin/sh

# This script is designed for phasing reads using WhatsHap

phased_vcf_file=/path/to/phased/vcf.gz
genome_file=/path/to/genome.fa
bam_files=$(ls /path/to/aligned/file/*Aligned.sortedByCoord.out.bam)

for bam in ${bam_files}; do
  whatshap haplotag -o ${bam}_phased.bam --reference ${genome_file} ${phased_vcf_file} ${bam} --ignore-read-groups
done
