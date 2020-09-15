#!/bin/sh

# This script is designed for alignment of short reads using STAR.

genome=/path/to/STAR/index
fastq_folder=/path/to/fastq/files
fastq_files=$(ls /path/to/fastq/files/*.r_1_val_1.fq.gz)

for fastq in ${fastq_files}; do
  fastq_name=$(basename ${fastq} | sed "s/.r_1_val_1.fq.gz//g")

  STAR --runThreadN 8 \
  --genomeDir ${genome} --readFilesIn ${fastq_folder}/${fastq_name}.r_1_val_1.fq.gz ${fastq_folder}/${fastq_name}.r_2_val_2.fq.gz \
  --outFilterMultimapNmax 1 --outSAMtype BAM SortedByCoordinate \
  --outFileNamePrefix ${fastq_folder}/${fastq_name}_ --quantMode TranscriptomeSAM --readFilesCommand zcat
done