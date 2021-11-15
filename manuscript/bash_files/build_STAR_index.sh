#!/bin/sh

# This script is designed for building index for alignment using STAR.

genome=/path/to/genome.fa
annotation=/path/to/annotation.gtf
output=/path/to/STAR/index/

STAR --runMode genomeGenerate --runThreadN 25 --genomeDir ${output} --genomeFastaFiles ${genome} --sjdbGTFfile ${annotation}
