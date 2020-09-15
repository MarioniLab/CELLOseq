#!/bin/bash

# CELLO-Seq Sarlacc pipeline - alignment
# Author: Rebecca Berrens, Andrian Yang, Aaron Lun, Florian Bieberich

# This script is designed for alignment of long reads using minimap2.

species=human
fastq_list=$(ls /path/to/fastq/folder/*.fastq)

nproc=5

reference_folder=/path/to/reference/folder
index_type=(transcript genome)
if [ "$species" == "human" ]
then
  species_folder=human_GRCh38_p13
  index_files=(human_GRCh38_v38_transcript_ercc_repeats.fa.mmi GRCh38.p13.genome.fa.mmi)
elif [ "$species" == "mouse" ]
then
  species_folder=mouse_GRCm38_p6
  index_files=(mouse_GRCm38_p6_transcripts_ercc_repeats.fa.mmi GRCm38.p6.genome.fa.mmi)
fi

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_files}"
echo "FASTQ files to be processed are ${fastq_list}"

for fastq in ${fastq_list}; do
  for i in "${!index_files[@]}"; do
    minimap2 -K 200M --eqx --MD -t ${nproc} -ax splice -uf --secondary=no -C5 \
    ${reference_folder}/${species_folder}/${index_files[$i]} ${fastq} > ${fastq%fastq}.${index_type[$i]}.sam
  done
done