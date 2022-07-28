#!/bin/bash
#SBATCH --time=00:02:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=128gb
#SBATCH --partition=Orion

module load anaconda3
#Order as follows: python3 <.py file> <.csv file of intervals> <.gff or .gff3 file of gene features> <annotation file of gene loci and GO terms>
python3 GenesInInterval.py SignificantIntervals.csv Sbicolor_454_Chr03_gene.gff3 Sbicolor_454_v3_1_1_annotation_info.txt
