---
title: "R Notebook"
output: html_notebook
---

```{r}
library(GenomicRanges)
library(rtracklayer)
library(Rsamtools)

GTFfile = "/home/ftencaten/Downloads/Homo_sapiens.GRCh38.99.gtf.gz"
FASTAfile = "/home/ftencaten/Downloads/Homo_sapiens.GRCh38.dna.primary_assembly.fa"

#Load the annotation and reduce it
GTF <- import.gff(GTFfile, format="gff", genome="GRCh38.99", feature.type="exon")
grl <- reduce(split(GTF, elementMetadata(GTF)$gene_id))
reducedGTF <- unlist(grl, use.names=T)
elementMetadata(reducedGTF)$gene_id <- rep(names(grl), elementNROWS(grl))

#Open the fasta file
FASTA <- FaFile(FASTAfile)
open(FASTA)

#Add the GC numbers
#elementMetadata(reducedGTF)$nGCs <- letterFrequency(getSeq(FASTA, reducedGTF), "GC")[,1]
elementMetadata(reducedGTF)$widths <- width(reducedGTF)

#Create a list of the ensembl_id/GC/length
calc_GC_length <- function(x) {
    nGCs = sum(elementMetadata(x)$nGCs)
    width = sum(elementMetadata(x)$widths)
    c(width, nGCs/width)
}
output <- t(sapply(split(reducedGTF, elementMetadata(reducedGTF)$gene_id), calc_GC_length))
colnames(output) <- c("Length", "GC")

write.table(output, file="GC_lengths.tsv", sep="\t")
```
