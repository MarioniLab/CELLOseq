#!/bin/sh

# CELLO-Seq Sarlacc pipeline - index building
# Author: Rebecca Berrens, Andrian Yang, Aaron Lun, Florian Bieberich

# This script is designed for build index for alignment with minimap2.

reference_files=$(ls /path/to/reference.fa)

for x in ${reference_files}; do
 minimap2 -d ${x}.mmi ${x}
done
