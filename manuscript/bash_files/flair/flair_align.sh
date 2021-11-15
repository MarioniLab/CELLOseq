#!/bin/sh

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we first align reads to the genome using minimap2

species=human
fastq_list=$(ls /path/to/fastq/folder/*.fastq)

reference_folder=/path/to/reference/folder
if [ "$species" = "human" ]
then
  species_folder=human_GRCh38_p13
  index_file=GRCh38.p13.genome.fa
elif [ "$species" = "mouse" ]
then
  species_folder=mouse_GRCm38_p6
  index_file=GRCm38.p6.genome.fa
fi

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_file}"
echo "FASTQ files to be processed are ${fastq_list}"

for fastq in ${fastq_list}; do
  /flair/flair.py align -g ${reference_folder}/${species_folder}/${index_file} \
  -r ${fastq} -o ${fastq%fastq}_flair
done



