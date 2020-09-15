#!/bin/sh

# This script is designed for lifting over variants called with hg37 genomic coordinate to hg38 genomic coordinate

vcf_file=/path/to/vcf/file.vcf
chain_file=/path/to/b37ToHg38.over.chain
genome_file=/path/to/hg38/genome.fa

# We first prepare the genome dictionary
gatk CreateSequenceDictionary -R=${genome_file} -O=/path/to/genome.dict

gatk LiftoverVcf -I=${vcf_file} -O=${vcf_file%vcf}lifted_over.vcf -C=${chain_file} \
--REJECT={vcf_file%vcf}rejected_variants.vcf -R=${genome_file}