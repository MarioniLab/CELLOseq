# MOUSE
# Filter for transposons in flair isoform file
# filter GTF file to not contain simple repeats
grep -v "rich" repeats_GRCm38_20200523_unique.gtf | grep -v "U[0-9]" | grep -v "tRNA" | \
grep -v "rRNA" | grep -v "SRNA" | grep -v "7SL" > repeats_GRCm38_20200523_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf

#filter out ERCCs and filter for genes
grep -v "ERCC" 2cell_all_corrected_fixed.fastq_flair.bed_sjs_correct_all_corrected.psl_salmon_collapse_corrected.isoforms.gtf \
| grep "exon" > 2cell_flair_corrected_isoforms_noERCC_exon.gtf

# bed intersect genome GTF and flair GTF
bedtools intersect -v -s -b gencode.vM23.annotation.gtf \
-a 2cell_flair_corrected_isoforms_noERCC_exon.gtf \
> 2cell_flair_corrected_isoforms_noERCC_exon_woGenome.gtf

# filter against known TEs
grep -v "barcode_[0-9]*[0-9]*_" 2cell_flair_corrected_isoforms_noERCC_exon_woGenome.gtf \
> 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats.gtf

# intersect filtered flair GTF with repeat GTF
bedtools intersect -wo -b repeats_GRCm38_20200523_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf \
-a 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats.gtf \
> 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats.gtf

# filter for overlap bigger than 100
awk '$27 >= 100' 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats.gtf \
> 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats_100.gtf

awk '{print $12, $24}' 2cell_flair_corrected_isoforms_noERCC_exon_woGenome_woknownRepeats_repeats_100.gtf | uniq \
> 2cell_repeat_readnames.txt


# Filter for transposons derived isoforms in flair isoform file
# filter for gene IDs, remove transcripts, retain only exons, remove ERCCS
grep ENSMUSG 2cell_all_deduplicated_fixed.fastq_flair.bed_sjs_correct_all_corrected.psl_salmon_collapse_corrected.isoforms.gtf \
| grep -v ENSMUST | grep exon | grep -v ERCC \
> 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon.gtf

# intersect filtered flair GTF with repeat GTF
bedtools intersect -s -b repeats_GRCm38_20200523_unique_noRich_noSNRNA_notRNA_norRNA_noSRNA_no7SL.gtf \
-a 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon.gtf -wo \
> 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms.gtf

# negatively intersect genome GTF
bedtools intersect -v -f 1 -b gencode.vM23.annotation_exons.gtf \
-a 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms.gtf \
> 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic.gtf

# filter for overlap 
awk '$26 >= 100' 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic.gtf > 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100.gtf

# overlap nested repeat names
bedtools intersect -s -a 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100.gtf \
-b GRCm38_nestedRepeats_20200703_exons.tsv -wo \
> 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_nested.gtf

bedtools intersect -v -s -a 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100.gtf \
-b GRCm38_nestedRepeats_20200703_exons.tsv -wo \
> 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_not_nested.gtf


awk '{print $12, $22, $35}' 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_nested.gtf | uniq \
> 2cell_repeat_isoform_readnames_nested.txt
awk '{print $12, $22}' 2cell_flair_corrected_isoforms_noTranscript_exons_noERCC_exon_repeat_isoforms_no_genic_100_not_nested.gtf | uniq \
> 2cell_repeat_isoform_readnames_not_nested.txt



