#File Processing
SYRI was used on 10 sorghum assemblies to identify structural variants with reference to the BTx623 reference genome.  
1) I extracted specific variant types of interest (e.g. duplications) from each strain's vcf file (using AWK in command line).
2) Then I formatted this output and marked the occurence of each allele present (using python scripts).
3) Then I merged all formatted files to create a master file of allele occurence across these genomes (using command line and bcftools).

- Slurm files show this process and output the final merged file.
- Some duplication features had a lot of overlap, with similar start/end positions.  These were processed out using DuplicationProcessing.py and the non-overlapping features were analyzed further.
- Inversions and translocations can be processed with just the respective slurm files and AddColumns.py
