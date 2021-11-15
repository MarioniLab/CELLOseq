#!/bin/sh

#INITIALISE FOLDERS
my_folder={PATH_TO_FOLDER}
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

mkdir -p ${out_folder}
mkdir -p ${err_folder}

#CHOOSE PARAMETERS
#RAM in megabytes
memory=230000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=3
queue=research-rh74

script_name=demultiplex

simg=sarlacc.img

specified=$(ls ${my_folder}/{PATH_TO_RMD)

for my_file in ${specified}
do
  script_name=$(basename ${my_file})
  rmd_file=${my_file}

  lsf_path={PATH_TO_LSF}

  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  "SINGULARITYENV_APPEND_PATH=$lsf_path singularity exec -B /ebi/lsf/ $simg R --vanilla -e \"rmarkdown::render('$rmd_file')\""
done
