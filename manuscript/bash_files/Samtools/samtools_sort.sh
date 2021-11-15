#!/bin/sh

#INITIALISE FOLDERS
my_folder=/path/to/folder
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

#CHOOSE PARAMETERS
#RAM in megabytes
memory=600000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=8
queue=research-rh74

script_base_name=samtools_index

bam_files=$(ls ${my_folder}/*.bam)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for bam in ${bam_files}; do
  bsub -e ${err_folder}/${script_name} \
  -P bigmem -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  samtools sort ${bam} -o ${bam}.sorted.bam
done
