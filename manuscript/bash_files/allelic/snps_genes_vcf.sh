# filter phased snps only
grep -v "/" GRCh38_filtered.vcf > GRCh38_filtered_phased.vcf

# filter heterozygous snps only
grep -v '0|0\|1|1' GRCh38_filtered_phased.vcf > GRCh38_filtered_phased_het.vcf


# count the number of snps per transcript
bsub -n 5 -M 10000 -o job_out -e job_err -R "rusage[scratch=10000]" "bedtools intersect -wo -a GRCh38_filtered_phased_het.vcf \
-b gencode.v32.annotation.gtf \
> snps_phased_het_gencode.bed"

# grep exons and protein coding genes only 
awk '$13 == "exon"' snps_phased_het_gencode.bed > snps_phased_het_gencode_exons.bed

bsub -n 20 -M 60000 -P bigmem -o job_out -e job_err -R "rusage[scratch=60000]" \
"awk '{print $1,$2,$3,$4,$5,$11,$13,$14,$15,$17,$20,$22,$24}' snps_phased_het_gencode_exons.bed \
> snps_phased_het_gencode_exons_selected"

# zip and index
bgzip -c GRCh38_filtered_phased_het.vcf > GRCh38_filtered_phased_het.vcf.gz
tabix -p vcf GRCh38_filtered_phased_het.vcf.gz

# unzip
bgzip -d