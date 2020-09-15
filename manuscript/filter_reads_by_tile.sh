#!/bin/sh

# This script is designed for filtering of Illumina reads based on tile using FilterByTile from BBMap package.

fastq_combined_file=/path/to/combined/fastq.fq.gz
fastq_files=$(ls /path/to/fastq/*.r_1.fq.gz)

# We first need to create a statistical profile from all reads sequenced in the same flowcell.
combined_file_prefix=$(echo $fastq_combined_file | sed "s/.r_1.fq.gz//")
/bbmap/filterbytile.sh in1=${combined_file_prefix}.r_1.fq.gz in2=${combined_file_prefix}.r_2.fq.gz \
  dump=all_reads.filterbytile.dump

# We then perform filter per fastq using the statistical profile created.
for fastq in ${fastq_files}; do
  r1_prefix=$(echo $fastq | sed "s/.r_1.fq.gz//")

  /bbmap/filterbytile.sh in1=${r1_prefix}.r_1.fq.gz in2=${r1_prefix}.r_2.fq.gz \
  out1=${r1_prefix}.filtered.r_1.fq.gz out2=${r1_prefix}.filtered.r_2.fq.gz \
  indump=all_reads.filterbytile.dump
done 
