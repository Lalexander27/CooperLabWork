# Circos Plots
- I [prepared](CircosPrep.Rmd) files of duplications, insertions, and deletions for visualization in circos plots.  
- For each 1M bp interval, I compared counts of features for sweet and biomass strains, then used average difference to organize these intervals in quantiles. 
- For [circos plots](finalCircos.R), I visualized intervals that had greatest divergence (top [50](Circos50Quantile.png) percentiles and top [5](Circos95Quantile.png) percentiles). Note that orange indicates intervals at which sweet varieties had greater mean counts of a feature than biomass varieties, and blue indicates intervals where biomass strains had greater counts of a feature. 
