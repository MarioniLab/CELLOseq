#!/bin/sh

# CELLO-Seq Sarlacc pipeline - filter reads by length
# Author: Rebecca Berrens, Andrian Yang, Aaron Lun, Florian Bieberich

# This script is designed to filter for reads longer than 20 Kb due to an issue with the Biostring package when handling very long reads.
# (https://github.com/Bioconductor/Biostrings/issues/20)

fastq_file=/path/to/fastq/file.fastq
read_length=20000

cat ${fastq_file} | paste - - - - | awk -v read_length="$read_length" 'length($2) <= read_length' | sed 's/\t/\n/g' > \
 ${fastq_file%fastq}filtered.fastq