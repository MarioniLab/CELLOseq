#!/bin/sh

# In this script, we both produce the gene count matrix and assign reads to corresponding genes using featureCounts.
# This script is used in both quantifying genes after deduplication with GATK MarkDuplicates and in the umitools pipeline.

annotation=/path/to/gene/annotation.gtf
bam_files=$(ls /path/to/bam/*.sortedByCoord.out.bam)

for bam in ${bam_files}; do
 featureCounts -T 8 -p -a ${annotation} -o ${bam%bam}counts.txt -R BAM ${bam}
done
