#!/bin/sh

#INITIALISE FOLDERS
my_folder=path/to/folder
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

#CHOOSE PARAMETERS
#RAM in megabytes
memory=24000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=8
queue=research-rh74

script_name=extract_col_allele_2

count_files=$(ls ${my_folder}/path/to/flair/counts/table)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for count in ${count_files}; do
  count_name=$(basename ${count} | sed "s//path/to/flair/counts/table//g")
  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  "cut -f1,7 ${count} > ${my_folder}/${count_name}_allele_2"
done
