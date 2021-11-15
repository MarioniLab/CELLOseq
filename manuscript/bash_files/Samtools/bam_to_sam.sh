#!/bin/sh

#INITIALISE FOLDERS
my_folder=/path/to/folder
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

#CHOOSE PARAMETERS
#RAM in megabytes
memory=24000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=8
queue=research-rh74

script_name=samtools_index

bam_files=$(ls ${my_folder}/path/to/bam_files)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for bam in ${bam_files}; do
  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  samtools view -h -o ${bam}.sam ${bam}
done
