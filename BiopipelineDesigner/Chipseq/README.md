# Chipseq Pipeline

## Context
This ChIP-seq processing pipeline implemented in the Biopipeline Designer starts with raw ChIP-seq sequences (1) and ends with viewing TF binding locations (peak calling; 4) and protein enrichment at a given motif (e.g. how well does the protein bind to a given DNA sequence; 5). Major processing steps, and the order in which they occur, are outlined below:

1. Download raw ChIP-seq data (FASTQ-formatted files) from SRA (FasterqDump)
2. Align reads to a reference genome (BwaMEM)
3. Call TF enrichment peaks (UserFunction; MACS3)
4. Visualize aligned reads and peak locations (GenomicsViewer)
5. Plot FNR motif enrichment (UserFunction; custom MATLAB script)

Some blocks are used right out of the box (e.g. FasterqDump, BwaMEM, GenomicsViewer), some UserFunction blocks call shipping MATLAB functions directly (seqqcplot, gunzip), while others call custom MATLAB functions (motifCoverageUF) that call 3p tools (macs3UF).

## Data set
Data set is obtained from [GSE41195](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE41195) on GEO. These data characterize the binding of the FNR transcription factor in E Coli (specifically the ASM584v2 strain) under anaerobic conditions. FNR is functionally inactivated by the presence of oxygen, and is thus activated in oxygen's absence. FNR regulates anaerobiosis by binding near genes involved in anaerobic metabolism, and generally acts as an activator of gene expression. The consensus binding sequence, or "motif", for FNR is TTGAT****ATCAA. 

## Running the pipeline
This pipeline needs to run in Linux because of MACS3.
To that purpose, you can build a docker container within the Windows Subsystem for Linux, if you use Windows.
See [README.md](Dockerfile/README.md) for more information.
