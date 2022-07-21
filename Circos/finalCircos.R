access = "Louie"

if(access =="Louie") {
  setwd("C:\\Users\\louie\\Desktop\\ResearchFiles\\RPlotting\\CircosPlotsFiles")
}

if (!require(readxl)) {
  install.packages("readxl")
}
if (!require(tidyverse)) {
  install.packages("tidyverse")
}
if (!require(circlize)) {
  install.packages("circlize")
}

library(readxl)
library(tidyverse)
library(circlize)

tiff("C:\\Users\\louie\\Desktop\\ResearchFiles\\RPlotting\\CircosPlotsFiles\\CircosHighRes95.png", width=7, height=7, units="in", res=300)

#Read in tracks
duplication <- read.table("DuplicationComparisons_SV.csv",header=TRUE,sep = ',')
deletion <- read.table("DeletionComparisons_SV.csv",header=TRUE,sep = ',')
insertion <- read.table("InsertionComparisons_SV.csv",header=TRUE,sep = ',')

### Read in the chromosome intervals (1M bp interval)
chr <- read.csv("chromosomes.csv", header=TRUE)

### Initialize the plot and the plotting regions
circos.par("track.height" = 0.15)
circos.initialize(factors=chr$chr, xlim=as.matrix(chr[,2:3]))
circos.trackPlotRegion(ylim=c(0,1), bg.col=rep("white", 10), bg.border=rep("white",10))


### Label the Sorghum chromosomes
chr.center = as.integer(chr$end/2)
y = rep(1, 10) + uy(5, "mm")
for (i in 1:10) {
  circos.text(x=chr.center[i], y=y[i], paste("Chr", i, sep=" "), sector.index=chr$chr[i])
}

### Add rectangles for the alignment blocks
library(RColorBrewer)
my.colors= c("light gray", "#F17720", "#0474BA")

#gray is no difference in duplications; blue is sweet sorghum >; green is biomass sorghum >
for (i in 1:nrow(duplication)) {
  circos.rect(xleft=duplication$interval[i], ybottom=0,
              xright=duplication$END[i], ytop=1,
              sector.index=duplication$CHROM[i], col=my.colors[duplication$Color95Q[i]], border=NA)
}


### On the next track, add color coded rectangles for deletion blocks
circos.trackPlotRegion(ylim=c(0,1), bg.col=rep("white", 10), track.height=0.12, bg.border=rep("white", 10))

for (i in 1:nrow(deletion)) {
  circos.rect(xleft=deletion$interval[i], ybottom=0,
              xright=deletion$END[i], ytop=1,
              sector.index=deletion$CHROM[i], col=my.colors[deletion$Color95Q[i]], border=NA)
}


##On the next track, add color coded rectangles for insertions
circos.trackPlotRegion(ylim=c(0,1), bg.col=rep("white", 10), track.height=0.12, bg.border=rep("white", 10))

for (i in 1:nrow(insertion)) {
  circos.rect(xleft=insertion$interval[i], ybottom=0,
              xright=insertion$END[i], ytop=1,
              sector.index=insertion$CHROM[i], col=my.colors[insertion$Color95Q[i]], border=NA)
}

