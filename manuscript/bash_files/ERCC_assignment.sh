#!/bin/sh

#INITIALISE FOLDERS
my_folder={PATH_TO_SHORTREAD_DATA}
out_folder=${my_folder}/clust_out
err_folder=${my_folder}/clust_err

#CHOOSE PARAMETERS
#RAM in megabytes
memory=24000
r_command="rusage[mem=${memory}]"
#num_processors
nproc=8
queue=research-rh74

script_base_name=gene_assignment

annotation={PATH_TO_ERCC_GTF}/ERCC.gtf
bam_files=$(ls ${my_folder}/*sorted.bam)

mkdir -p ${out_folder}
mkdir -p ${err_folder}

for bam in ${bam_files}; do
  bam_name=$(basename ${bam} | sed "s/allele_{1,2}.bam//g")
  script_name=${script_base_name}_${bam_name}
  out=${my_folder}/${bam_name}_counts_dedup.txt
  bsub -e ${err_folder}/${script_name} \
  -o ${out_folder}/${script_name} -q $queue \
  -M $memory -R $r_command -n $nproc -J ${script_name} \
  featureCounts -T 8 -p -a ${annotation} -o ${bam}_counts_dedup.txt -R BAM ${bam}
done
