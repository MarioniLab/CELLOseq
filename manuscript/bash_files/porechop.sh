for i in {PATH_TO_FASTQ}/*fastq
do
bsub -n 10 -M 10000 -R "rusage[mem=10000]" -o porechop_out -e porechop_err \
"singularity exec ~/images/porechop.img porechop \
-i "${i}" \
-o "${i%.fastq}"_chopped.fastq \
-t 20 /
--extra_middle_trim_good_side 0 \
--extra_middle_trim_bad_side 0"
done
