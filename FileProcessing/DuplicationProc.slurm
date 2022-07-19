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

#This adds the proper header and counts alleles for eahc filtered file
python3 AddColumns.py pi300119_NoOverlap.vcf 300119
python3 AddColumns.py pi329311_NoOverlap.vcf 329311
python3 AddColumns.py pi506069_NoOverlap.vcf 506069
python3 AddColumns.py pi510757_NoOverlap.vcf 510757
python3 AddColumns.py pi655972_NoOverlap.vcf 655972
python3 AddColumns.py CA_NoOverlap.vcf CA
python3 AddColumns.py leoti_NoOverlap.vcf leoti
python3 AddColumns.py rio_NoOverlap.vcf rio
python3 AddColumns.py pi229841_NoOverlap.vcf 229841
python3 AddColumns.py pi297155_NoOverlap.vcf 297155

#This prepares above files to be merged using bcftools
module load samtools
for x in *Mergable.vcf
do
bgzip $x
done
for x in *.gz
do
tabix -p vcf $x
done


module load vcftools
bcftools merge -0 -i 'ChrB:join,Parent:join,DupType:join' -O v -o final_duplications.vcf pi300119_NoOverlap_Mergable.vcf.gz pi329311_NoOverlap_Mergable.vcf.gz pi506069_NoOverlap_Mergable.vcf.gz pi510757_NoOverlap_Mergable.vcf.gz pi655972_NoOverlap_Mergable.vcf.gz CA_NoOverlap_Mergable.vcf.gz leoti_NoOverlap_Mergable.vcf.gz rio_NoOverlap_Mergable.vcf.gz pi229841_NoOverlap_Mergable.vcf.gz pi297155_NoOverlap_Mergable.vcf.gz
