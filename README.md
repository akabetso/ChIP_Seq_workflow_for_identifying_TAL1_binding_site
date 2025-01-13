# *ChIp-Seq pipeline for Identification of the binding sites of the T-cell acute lymphocytic leukemia protein 1 (TAL1)*

### Compiled by *Desmond Akabetso Nde*
### Last updated on the *13 of January 2025*
### *Enjoy reading through and do not hesitate to comment your thoughts on my approach and analysis.*

The aim of this study is to:
- Reproduce the ChIP-Seq pipeline from [Galaxy](https://training.galaxyproject.org/training-material/topics/epigenetics/tutorials/tal1-binding-site-identification/tutorial.html)
- Investigate the dynamics of occupancy and the role in gene regulation of the transcription factor TAL1, a critical regulator of hematopoiesis, at multiple stages of hematopoietic differentiation. 

## Workflow from Galaxy
1. Quality control
2. Trimmin and clipping reads
3. Aligning reads to a reference genome
4. Assessing correlation between samples
5. Assessing IP strength
6. Determining TAL1 binding sites
7. Inspection of peaks and aligned data (IGV)
8. Identifying unique and common TAL1 peaks between stages
9. Generating Input normalized coverage files
10. Plot the signal on the peaks between samples
11. conclusion

### Dataset
This dataset was published from a study by [Wu et al. 2014](https://genome.cshlp.org/content/24/12/1945). This dataset was downsampled and uploaded on [zenodo](https://zenodo.org/records/197100) for rapid processing on a local machine. It consist of a biological replicate TAL1 ChIP-Seq and input control experiments. Input control experiments are used to Identify and remove sampling bias such as open|accessible chromatin or GC bias. 
The ChIP-Seq experiments were performed in multiple mouse cell types including G1E - a GATA-null immortalized cell line derived from targeted disruption of GATA-1 in mouse embryonic stem cells and megakaryocytes. 

### Quality control
First step was to run quality control with fastQC, The end of the reads fell below phred score of 20 (at least 1% base is incorrect) which is normal for ilumina siquencing because of signal decal or phase biase at the end of the reads.

Reads below 20 phred score was trimmed with Trimmomatic in single-reads mode. After trimming, reads length span a range of values. 

### Alignment

