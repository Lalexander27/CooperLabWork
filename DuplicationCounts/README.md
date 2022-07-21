# Duplication Counts and Permutation Testing
- I took the master list of duplications across the genomes and [used R](DuplicationCounts1Mbp.Rmd) to count the number of duplications per strain per chromosome over per 1M bp intervals.  I removed the grassl line (300119) from analyses since it is neither a sweet nor biomass variety, then I found the differences in average duplications for sweet vs. biomass varieties.  I visualized these differences and exported results as a .csv

- I then used these permutation testing to find intervals that had a significantly extreme difference in duplication counts for these intervals.  I wrote the permutation function so that I could adjust the number of permutations to run.
