#!/bin/sh

# This script is designed for filtering transposon and transposon derived isoform from FLAIR isoform file

species=mouse
annotation_file=/path/to/annotation.gtf
repeat_file=/path/to/repeat.gtf
nested_repeat_file=/path/to/nested/repeat.tsv
flair_isoform_file=/path/to/flair/isoform.gtf
final_output_prefix=/path/to/final/output/prefix

if [ "$species" = "human" ]
then
  gene_prefix=ENGS
  transcript_prefix=ENST
elif [ "$species" = "mouse" ]
then
  gene_prefix=ENSMUSG
  transcript_prefix=ENSMUST
fi

###########
# Filtering for transposons isoform
###########

# We filter known annotation for exons:
grep "exon" ${annotation_file} > ${annotation_file%gtf}_exons.gtf

# We filter the repeat GTF file to remove simple repeats
grep -v "rich" ${repeat_file} | grep -v "U[0-9]" | grep -v "tRNA" | grep -v "rRNA" \
| grep -v "SRNA" | grep -v "7SL" > ${repeat_file%gtf}_noSimpleRepeats.gtf

# We filter nested repeat file for exons:
grep "exon" ${nested_repeat_file} > ${nested_repeat_file%tsv}_exons.tsv

# We filter out ERCCs from the flair isoform file and select only exon entries 
grep -v "ERCC" ${flair_isoform_file} | grep "exon" > ${flair_isoform_file%gtf}_noERCC_exon.gtf

# We filter out known annotation from the filtered flair isoform
bedtools intersect -v -s -b ${annotation_file} -a ${flair_isoform_file%gtf}_noERCC_exon.gtf \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome.gtf

# We also filter out known TEs from the filtered flair isoform
grep -v "barcode_[0-9]*[0-9]*_" ${flair_isoform_file%gtf}_noERCC_exon_noGenome.gtf \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats.gtf

# We then select for isoform which overlaps with the repeat GTF file
bedtools intersect -b ${repeat_file%gtf}_noSimpleRepeats.gtf \
-a ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats.gtf -wo \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats.gtf

# We filter for overlaps longer than 100 bp
awk '$27 >= 100' ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats.gtf \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp.gtf

# Finally, we filter for overlapping entry with nested repeat file
bedtools intersect -s -a ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp.gtf \
-b ${nested_repeat_file%tsv}_exons.tsv -wo \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp_nested.gtf

# and for non-overlapping entry with nested repeat file
bedtools intersect -v -s -a ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp.gtf \
-b ${nested_repeat_file%tsv}_exons.tsv -wo \
> ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp_noNested.gtf

awk '{print $12, $23, $36}' ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp_nested.gtf | uniq \
> ${final_output_prefix}_repeat_readnames_nested.txt
awk '{print $12, $23}' ${flair_isoform_file%gtf}_noERCC_exon_noGenome_noKnownRepeats_overlapRepeats100bp_noNested.gtf | uniq \
> ${final_output_prefix}_repeat_readnames_noNested.txt

###########
# Filtering for transposons derived isoforms
###########

# We filter out gene, transcript and ERCCs from the flair isoform file and select only exon entries 
grep ${gene_prefix} ${flair_isoform_file} | grep -v ${transcript_prefix} | grep exon | grep -v ERCC \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon.gtf

# We then select for isoform which overlaps with the repeat GTF file
bedtools intersect -s -b ${repeat_file%gtf}_noSimpleRepeats.gtf \
-a ${flair_isoform_file%gtf}_noTranscript_noERCC_exon.gtf -wo \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats.gtf

# We filter out known exons from the filtered flair isoform
bedtools intersect -v -f 1 -b ${annotation_file%gtf}_exons.gtf \
-a ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats.gtf \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats_noGenic.gtf

# We filter for overlaps longer than 100 bp 
awk '$26 >= 100' ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats_noGenic.gtf \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic.gtf

# Finally, we filter for overlapping entry with nested repeat file
bedtools intersect -s -a ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic.gtf \
-b ${nested_repeat_file%tsv}_exons.tsv -wo \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic_nested.gtf

# and for non-overlapping entry with nested repeat file
bedtools intersect -v -s -a ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic.gtf \
-b ${nested_repeat_file%tsv}_exons.tsv -wo \
> ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic_noNested.gtf

awk '{print $12, $22, $35}' ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic_nested.gtf | uniq \
> ${final_output_prefix}_repeat_isoform_readnames_nested.txt
awk '{print $12, $22}' ${flair_isoform_file%gtf}_noTranscript_noERCC_exon_overlapRepeats100bp_noGenic_noNested.gtf | uniq \
> ${final_output_prefix}_repeat_isoform_readnames_noNested.txt


