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

base_script_name=combine_sam_samheader

sam_files=$(ls ${my_folder}/*allele_{1,2}.sam)
sam_header=$(ls ${my_folder}/*sam_header)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for sam in ${sam_files}; do
  sam_name=$(basename ${sam} | sed "s/_allele_[12].sam//g")
  script_name=${base_script_name}_${sam_name}
  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  "cat ${my_folder}/${sam_name}_sam_header ${sam} > ${sam}_with_header.sam"
done
