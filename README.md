# CooperLab
Overall, this project was to identify structural variants in 9 Sorghum bicolor strains.  The genomes were compared to the reference BTx623.
I specifically compared patterns of duplications in sweet (sugar-accumulating) and biomass/cellulosic (tall-growing and leafy) varieties.
1) After obtaining SyRI annotation info for 9 strains, I [processed files](FileProcessing) to create a master file of all non-overlapping duplications across the strains
2) I [plotted](DuplicationCounts/DuplicationCounts1Mbp.Rmd) patterns of duplications across 1M bp intervals across the genome.  I also found the average differences in duplication counts for sweet and cellulosic varieties.
3) I [prepared](Circos/CircosPrep.Rmd) duplication, SNP, and insertion data for [circos plots](Circos/finalCircos.R).  Specifically, I highlighted 1M bp intervals that had large count differences in sweet and biomass strains.  I visualized graphs for intervals across the genome that were >= [50th](Circos/CircosHighRes50.png) percentile and that were >= [95th](Circos/CircosHighRes95.png) percentile.
4) I then [performed](DuplicationCounts/PermutationDuplications.Rmd) permutation testing to find intervals where sweet and biomass varieties had significantly different duplication counts.
5) Next, I [annotated](GeneAnnotations/GenesInInterval.py) these significant intervals for gene location info, and marked associated GO terms and functions in arabidopsis and rice genomes.  
6) I then performed GO term [enrichment analysis](GeneAnnotations/GOAnalyses.Rmd) to determine what GO terms and gene loci may be associated with divergences in duplication counts.
7) After determining [gene loci](GeneLociVisualizations/SignGO.txt) that were associated with significantly enriched GO terms, I [visualized](GeneLociVisualizations/Chr3Inv58_DuplGraph.png) the frequency of sweet and cellulosic duplications around these gene loci. 
