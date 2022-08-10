#!/bin/bash
#SBATCH --time=00:02:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=128gb
#SBATCH --partition=Orion

module load anaconda3
#This processes original vcf files and pulls out inverted duplication alignments and inverted alignments then saves output to new file
#Can change awk command to pull different structural variant types
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_300119.vcf > pi300119.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_329311.vcf > pi329311.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_506069.vcf > pi506069.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_510757.vcf > pi510757.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_655972.vcf > pi655972.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_CA.vcf > CA.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_leoti.vcf > leoti.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' rio_syri.vcf > rio.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_pi229841.vcf > pi229841.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' syri_uncorrected_pi297155.vcf > pi297155.vcf

#This processes out duplication alleles that have significant overlap in start/stop positions.
python3 DuplicationProcessing.py pi300119.vcf 30
python3 DuplicationProcessing.py pi329311.vcf 30
python3 DuplicationProcessing.py pi506069.vcf 30
python3 DuplicationProcessing.py pi510757.vcf 30
python3 DuplicationProcessing.py pi655972.vcf 30
python3 DuplicationProcessing.py CA.vcf 30
python3 DuplicationProcessing.py leoti.vcf 30
python3 DuplicationProcessing.py rio.vcf 30
python3 DuplicationProcessing.py pi229841.vcf 30
python3 DuplicationProcessing.py pi297155.vcf 30
