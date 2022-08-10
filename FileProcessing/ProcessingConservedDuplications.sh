#!/bin/bash
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=128gb
#SBATCH --partition=Orion

module load anaconda3
#This processes original vcf files and pulls out duplications then saves output to new file
#Can change awk command to pull different structural variant types
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi329311_mmSyri.vcf > pi329311.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi506069_mmSyri.vcf > pi506069.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi510757_mmSyri.vcf > pi510757.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi655972_mmSyri.vcf > pi655972.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' CA_mmSyri.vcf > CA.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' leoti_mmSyri.vcf > leoti.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' rio_mmSyri.vcf > rio.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi229841_mmSyri.vcf > pi229841.vcf
awk -F "\t" '$3 ~ /ID/ || $3 ~ /DUPAL/' pi297155_mmSyri.vcf > pi297155.vcf

#This processes out duplication alleles that have significant overlap in start/stop positions.
python3 DuplicationProcessing.py pi329311.vcf 30
python3 DuplicationProcessing.py pi506069.vcf 30
python3 DuplicationProcessing.py pi510757.vcf 30
python3 DuplicationProcessing.py pi655972.vcf 30
python3 DuplicationProcessing.py CA.vcf 30
python3 DuplicationProcessing.py leoti.vcf 30
python3 DuplicationProcessing.py rio.vcf 30
python3 DuplicationProcessing.py pi229841.vcf 30
python3 DuplicationProcessing.py pi297155.vcf 30

#This pulls nucmer syri outputs and then compares them to minimap syri outputs and reports duplications that appear in both files.
python3 DupSyri.py ../ProcessedVCF/Leoti_Duplications_NoDuplicates.vcf leoti_NoOverlap.vcf leoti
python3 DupSyri.py ../ProcessedVCF/CA_Duplications_NoDuplicates.vcf CA_NoOverlap.vcf CA
python3 DupSyri.py ../ProcessedVCF/Rio_Duplications_NoDuplicates.vcf rio_NoOverlap.vcf rio
python3 DupSyri.py ../ProcessedVCF/pi229841_Duplications_NoDuplicates.vcf pi229841_NoOverlap.vcf pi229841
python3 DupSyri.py ../ProcessedVCF/329311_Duplications_NoDuplicates.vcf pi329311_NoOverlap.vcf pi329311
python3 DupSyri.py ../ProcessedVCF/506069_Duplications_NoDuplicates.vcf pi506069_NoOverlap.vcf pi506069
python3 DupSyri.py ../ProcessedVCF/510757_Duplications_NoDuplicates.vcf pi510757_NoOverlap.vcf pi510757
python3 DupSyri.py ../ProcessedVCF/655972_Duplications_NoDuplicates.vcf pi655972_NoOverlap.vcf pi655972
python3 DupSyri.py ../ProcessedVCF/pi297155_Duplications_NoDuplicates.vcf pi297155_NoOverlap.vcf pi297155

#This adds the proper header and counts alleles for each filtered file
python3 AddColumns.py ConservedDuplications_pi329311.vcf pi329311
python3 AddColumns.py ConservedDuplications_pi506069.vcf pi506069
python3 AddColumns.py ConservedDuplications_pi510757.vcf pi510757
python3 AddColumns.py ConservedDuplications_pi655972.vcf pi655972
python3 AddColumns.py ConservedDuplications_CA.vcf CA
python3 AddColumns.py ConservedDuplications_leoti.vcf leoti
python3 AddColumns.py ConservedDuplications_rio.vcf rio
python3 AddColumns.py ConservedDuplications_pi229841.vcf pi229841
python3 AddColumns.py ConservedDuplications_pi297155.vcf pi297155

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

#This merges the files into a final file
module load vcftools
bcftools merge -0 -i 'ChrB:join,Parent:join,DupType:join' -O v -o final_duplications_conserved.vcf ConservedDuplications_pi329311_Mergable.vcf.gz ConservedDuplications_pi506069_Mergable.vcf.gz ConservedDuplications_pi510757_Mergable.vcf.gz ConservedDuplications_pi655972_Mergable.vcf.gz ConservedDuplications_CA_Mergable.vcf.gz ConservedDuplications_leoti_Mergable.vcf.gz ConservedDuplications_rio_Mergable.vcf.gz ConservedDuplications_pi229841_Mergable.vcf.gz ConservedDuplications_pi297155_Mergable.vcf.gz

