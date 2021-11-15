#!/bin/sh

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we define high-confidence isoforms from all of the corrected reads

species=human
combined_psl_file=/path/to/combined/corrected.psl
combined_fastq_file=/path/to/combined/fastq.fastq

reference_folder=/path/to/reference/folder
if [ "$species" = "human" ]
then
  species_folder=human_GRCh38_p13
  index_file=GRCh38.p13.genome.fa
  annotation_file=gencode.v32.annotation.gtf
elif [ "$species" = "mouse" ]
then
  species_folder=mouse_GRCm38_p6
  index_file=GRCm38.p6.genome.fa
  annotation_file=gencode.vM23.annotation.gtf
fi

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${index_file}"

/flair/flair.py collapse --reads ${combined_fastq_file} --query ${combined_psl_file} \
--gtf ${reference_folder}/annotation/${species_folder}/${annotation_file} \
--genome ${reference_folder}/sequences/${species_folder}/${index_file} \
--salmon /path/to/salmon \
--output ${combined_psl_file%psl}/_collapsed