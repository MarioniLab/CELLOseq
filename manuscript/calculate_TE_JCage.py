# By Vasavi Sundaram, adapted by Erica Pehrsson, 2016. Updated to python3 by Andrian Yang, 2020.
# Takes as input a RepeatMasker file from the UCSC Genome Browser
# Calculates the Jukes-Cantor evolutionary distance from subfamily consensus for individual TEs

# Load required packages
import os, sys, glob, math, gzip

# Confirm correct command line input
if len(sys.argv) != 2:
	print('''usage: {0}
	<output file>
	\n\n\n'''.format(sys.argv[0]))
	sys.exit()

# Output 
fout = sys.argv[1]
OUT = open(fout,'w')

# Find all the rmsk.txt.gz files in the current folder. 
# The output file will contain an identifier for each rmsk file that was processed, and that is the genome assembly identifier.
for fin in glob.glob("*txt"):
	species = os.path.basename(fin).split("_")[0]
	print(fin, '\t-', species)  # To keep track of which file was processed.
	with gzip.open(fin, 'rb') as IN:
		for line in IN:
			lst = line.strip().split('\t')
			p = int(lst[2])/1000.0  # The milliDiv column in the rmsk.txt.gz file. The table schema for the rmsk.txt.gz file on the UCSC Genome Browser contains this information.
			p_part = (4/3.0) * p 
			jc_dist = -0.75*(math.log(1-p_part))
			OUT.write('{0[5]}\t{0[6]}\t{0[7]}\t{0[10]}\t{0[12]}\t{0[11]}\t{0[9]}\t{1}\t{2}\n'.format(lst, p, jc_dist)) #Output format: chr, start, stop, TE subfamily, TE family, TE class, strand, (p)roportion of substitutions, Juke-Cantor distance
OUT.close()

# To calculate the TE age in million years of age (mya), we multiply the JC distance using the following formula:
# (JC_distance * 100) / (subsitution_rate * 2 * 100) * 1000
# For subsitution rate, we used 2.2 and 4.5 for human and mouse, according to Lander et al., 2001 and Waterston et al., 2002, respectively.