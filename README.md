# CooperLab
Overall, this project was to identify structural variants in 9 Sorghum bicolor strains.  The genomes were compared to the reference BTx623.
I specifically compared patterns of duplications in sweet (sugar-accumulating) and biomass (tall-growing and leafy) varieties.
1) After obtaining SyRI annotation info for 9 strains, I [processed files](FileProcessing) to create a master file of all non-overlapping duplications across the strains
2) I [plotted](DuplicationCounts/DuplicationCounts1Mbp.Rmd) patterns of duplications across 1M bp intervals across the genome.  I also found the average differences in duplication counts for sweet and biomass varieties.
3) I then [performed](DuplicationCounts/PermutationDuplications.Rmd) permutation testing to find intervals where sweet and biomass varieties had significantly different duplication counts.
4) I prepared duplication, SNP, and insertion data for circos plots.  Specifically, I highlighted 1M bp intervals that had large count differences in sweet and biomass strains.  I visualized graphs for intervals across the genome that were >= 50th percentile and that were >= 95th percentile.
5) 
