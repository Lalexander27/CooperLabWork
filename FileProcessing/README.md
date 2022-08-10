# File Processing
Nucmer was used to align 10 sorghum assemblies to identify structural variants with reference to the BTx623 reference genome, then SYRI was used to identify structural variants in these assemblies.  Line 300119 is excluded from further analyses since it is a wild sorghum line.
- I extracted specific variant types of interest (e.g. duplications) from each strain's vcf file using [AWK](DuplicationProc.slurm). I then [formatted](DuplicationProcessing.py) this output and [marked](AddColumns.py) the occurence of each allele present.
**Given the large number of duplications present in the nucmer-SYRI outputs, we decided to test the more conservative minimap aligner, then perform SYRI and filter duplications**  
- I filtered duplications from the minimap-SYRI output as described in (1) above. Then, I [filtered](DupSyri.py) the minimap-SYRI results and nucmer-SYRI results for duplications that were conserved in both files (i.e. duplications with aligned to similar positions on the reference genome, which originated from the same chromosome and similar position of the query assembly.)
- I merged all formatted files to create a master file of allele occurence across these genomes using [bcftools](ProcessingConservedDuplications.sh). Slurm files show this process and output the final merged file.  This [file](ExampleSyriOutput.vcf) can be used as an input for the slurm file.
- Some duplication features in the nucmer-SYRI output had a lot of overlap, with similar start/end positions.  These were processed out using DuplicationProcessing.py and the non-overlapping features were analyzed further. 
- Inversions and translocations can be [processed](OtherVariants) with slurm files and AddColumns.py.

