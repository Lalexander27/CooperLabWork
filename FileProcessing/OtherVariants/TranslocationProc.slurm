#!/bin/bash
#SBATCH --time=00:02:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=128gb
#SBATCH --partition=Orion

module load anaconda3
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_300119.vcf > pi300119.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_329311.vcf > pi329311.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_506069.vcf > pi506069.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_510757.vcf > pi510757.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_655972.vcf > pi655972.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_CA.vcf > CA.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_leoti.vcf > leoti.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' rio_syri.vcf > rio.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_pi229841.vcf > pi229841.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /INVTRAL/ || $3 ~ /TRANSAL/' syri_uncorrected_pi297155.vcf > pi297155.vcf

python3 AddColumns.py pi300119.vcf 300119
python3 AddColumns.py pi329311.vcf 329311
python3 AddColumns.py pi506069.vcf 506069
python3 AddColumns.py pi510757.vcf 510757
python3 AddColumns.py pi655972.vcf 655972
python3 AddColumns.py CA.vcf CA
python3 AddColumns.py leoti.vcf leoti
python3 AddColumns.py rio.vcf rio
python3 AddColumns.py pi229841.vcf 229841
python3 AddColumns.py pi297155.vcf 297155

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
bcftools merge -0 -i 'ChrB:join,Parent:join,DupType:join' -O v -o final_translocations.vcf pi300119_Mergable.vcf.gz pi329311_Mergable.vcf.gz pi506069_Mergable.vcf.gz pi510757_Mergable.vcf.gz pi655972_Mergable.vcf.gz CA_Mergable.vcf.gz leoti_Mergable.vcf.gz rio_Mergable.vcf.gz pi229841_Mergable.vcf.gz pi297155_Mergable.vcf.gz
