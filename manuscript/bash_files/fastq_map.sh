# This submits mapping jobs for a given set of FASTQ files
# against a given minimap index.

# Change the following variables only
species=human
file_location={PATH_TO_FASTQ}
out_location={PATH_TO_OUTPUT}
script_name=mapping

cluster=ebi
simg=~/images/flairdev.img
memory=20000 # For EBI, specify # in MB. For CRUK can specify using the following syntax #[G|M|K] (e.g. 20G)
nproc=5

if [ "$cluster" == "cruk" ]
then
	annotation_folder={PATH_TO_ANNOTATION}
elif [ "$cluster" == "ebi" ] 
then
	annotation_folder={PATH_TO_ANNOTATION}
	r_command="rusage[mem=${memory}]"
	queue=research-rh74
fi

if [ "$species" == "human" ]
then
  species_folder=human_GRCh38_p13
  reference_files=(human_GRCh38_p13_transcripts_ercc_repeats.fa.mmi GRCh38.p13.genome.fa.mmi)
elif [ "$species" == "mouse" ]
then
  species_folder=mouse_GRCm38_p6
  reference_files=(mouse_GRCm38_p6_transcripts_ercc_repeats.fa.mmi GRCm38.p6.genome.fa.mmi)
fi

name=(transcript genome)
fastqs=$(ls ${file_location}/*.fastq)
logs_location=${out_location}/logs
mkdir -p ${logs_location}

echo "Species set to ${species}"
echo "Species folder set to ${species_folder} and reference files set to ${reference_files}"
echo "FASTQ files to be processed are ${fastqs}"

for x in ${fastqs}; do
  for i in "${!reference_files[@]}"; do
    fname=$(basename ${x})
    prefix=$(echo ${fname} | sed "s/*fastq//g")

    if [ "$cluster" == "cruk" ]
	then
		sbatch << EOT
#!/bin/bash
#SBATCH -o ${logs_location}/${annotation}${prefix}.${name[$i]}.out
#SBATCH -e ${logs_location}/${annotation}${prefix}.${name[$i]}.err
#SBATCH -n 1
#SBATCH --mem ${memory}
#SBATCH --cpus-per-task=${nproc}
singularity exec -B ${simg} minimap2 -t ${nproc} -ax splice -uf --secondary=no -C5 \
"${annotation_folder}/${species_folder}/${reference_files[$i]}" \
${x} > "${out_location}/${x}.${name[$i]}.sam"
EOT
	elif [ "$cluster" == "ebi" ] 
	then
		bsub -e ${logs_location}/${annotation}${prefix}.${name[$i]}.err \
-o ${logs_location}/${annotation}${prefix}.${name[$i]}.out -q $queue \
-M $memory -R $r_command -n $nproc -J ${script_name} \
"singularity exec $simg minimap2 -t ${nproc} -ax splice -uf --secondary=no -C5 \
${annotation_folder}/${species_folder}/${reference_files[$i]} ${x} > ${out_location}/${fname}.${name[$i]}.sam"
	fi
  done
done
