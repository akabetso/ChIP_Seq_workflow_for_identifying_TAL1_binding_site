#!/bin/bash
mkdir -p "results/fastqc"
dir_results="results/fastqc"
mkdir -p logs
dir_logs="logs"
mkdir -p "results/cutadapt"
exec > >(tee $dir_logs/fastqc.log) 2>&1
echo "Starting fastqc..."
fastqc -o $dir_results data/female_oral2.gz 
echo "fastqc terminated"


#trimmig with cutadapt single-end reads
echo "starting trimming with cutadapt..."
cutadapt -a CTGTCTCTTATACACATCT -q 20 -m 20 -o results/cutadapt/trimmed_female_oral2.fastq.gz data/female_oral2.gz
echo "trimming with cutadapt terminated, options:"
echo "trimmed reads with phred score < 20"
echo "remove reads with bp less than 20"


# recheck quality control with fatsq
echo "Starting fastqc..."
fastqc -o "results/cutadapt/" results/cutadapt/trimmed_female_oral2.fastq.gz
echo "fastqc terminated"