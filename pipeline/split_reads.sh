#!/bin/sh

# CELLO-Seq Sarlacc pipeline - Split concatenated reads
# Author: Rebecca Berrens, Andrian Yang, Aaron Lun, Florian Bieberich

# This script is designed for splitting reads with internal adaptor (due to concatenation of reads) using porechop.
# For more details about porechop, please see https://github.com/rrwick/Porechop

fastq_file=$(ls /path/to/fastq/*.fq)

for fastq in $fastq_file; do
  porechop -i "${fastq}" -o "${fastq%.fastq}"_chopped.fastq -t 20 \
  --extra_middle_trim_good_side 0 --extra_middle_trim_bad_side 0
done
