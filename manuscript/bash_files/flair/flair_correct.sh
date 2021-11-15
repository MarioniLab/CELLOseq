#!/bin/sh

# This script forms the FLAIR pipeline for downstream analysis of CELLO-seq reads.
# For more detail on the pipeline, please see https://github.com/BrooksLabUCSC/flair
# In this script, we will correct misaligned splice site using both genome annotation and short-read splice junctions

species=human
bed_list=$(ls /path/to/fastq/folder/*.bed)

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
echo "BED files to be processed are ${bed_list}"

for bed in ${bed_list}; do
  /flair/flair.py correct --genome ${reference_folder}/${species_folder}/${index_file} \
  --query ${bed} --chromsizes ${reference_folder}/${species_folder}/sizes.genome \
  --gtf ${reference_folder}/${species_folder}/${annotation_file} \
  --output ${bed%bed}_sjs_correct --print_check \
  -j ${reference_folder}/${species_folder}/${annotation_file}_SJs.tsv
done

