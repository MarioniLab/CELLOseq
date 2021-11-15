README.txt

# prepare genome
liftover VCF
filter phased SNPS
filter heterozygous SNPs


# split reads based on phased genome
split_euts_nufh3_sr.sh 
samtools_index.sam on deduplicated.bam
whatshap.sh 
sam_header.sh 
grep_allele_1.sh
grep_allele_2.sh
combine_sam_samheader.sh
sam_to_bam.sh
gene_assignment.sh
extract_col_1.sh
extract_col_2.sh
