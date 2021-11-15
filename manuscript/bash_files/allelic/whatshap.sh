#!/bin/sh
# This script counts mapped allele files

#INITIALISE FOLDERS
my_folder=/path/to/folder
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

#CHOOSE PARAMETERS
#RAM in megabytes
memory=30000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=1

script_base_name=whatshap_mapping

simg=whatshap.img

vcf_file=$(ls /path/to/phased/vcf/)
genome=$(ls /path/to/genome/fasta/)

bam_files=$(ls ${my_folder}/*.dedup.bam)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for bam in ${bam_files}; do
  bam_name=$(basename ${bam} | sed "s/.bam//g")
  script_name=${script_base_name}_${bam_name}
  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  "singularity exec -B nanopore $simg \
  whatshap haplotag -o ${bam}.bam \
  --reference ${genome} \
  ${vcf_file} \
  ${bam} \
  --ignore-read-groups"
done
