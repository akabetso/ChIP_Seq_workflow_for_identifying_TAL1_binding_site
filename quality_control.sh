#!/bin/bash
set -e # exit on the first error
dir_results="results"
dir_logs="logs"
dir_genome="data/genome"
mkdir -p $dir_results
mkdir -p $dir_logs
mkdir -p "$dir_results/cutadapt"
mkdir -p "$dir_results/fastqc"
mkdir -p "$dir_results/trimmomatic"
#exec > >(tee $dir_logs/qaulity_control.log) 2>&1
#echo "Starting fastqc..."
#fastqc -o $dir_results/fastqc data/*.fastqsanger 
#echo "fastqc terminated"

# trimming with trimmomatic
#echo "start trimming..."
#for read in data/*R1*.fastqsanger; do
#    output="${read#data/}"
#    output="${output%.*}_trimmed.fastqsanger"
#    java -jar /usr/share/java/trimmomatic.jar SE "$read" "$dir_results/trimmomatic/$output" SLIDINGWINDOW:4:20
#
#done
#echo "trimming terminated"
#echo "only forward reads trimmed since the reverse reads passed quality control"

#echo "Starting second fastqc..."
#fastqc -o $dir_results/trimmomatic $dir_results/trimmomatic/*.fastqsanger.gz
#echo "second fastqc terminated"

# alignment with bwa

# index file 
#echo "generating index file with bwa..."
#bwa index $dir_genome/Mus_musculus.GRCm39.dna.primary_assembly.fa

# alinment SE
ref_genome="$dir_genome/Mus_musculus.GRCm39.dna.primary_assembly.fa"
dir_trimmed="data/quality_controled"
dir_aligned="data/aligned"

# Loop over all trimmed files
#echo "starting  SE alignment..."
##for R1 in $dir_trimmed/*R1*.fastqsanger; do
#for R in $dir_trimmed/*.fastqsanger; do
#    echo "starting $R alignment..."
    #basename=$(echo $(basename "$R1") | sed 's/_R1.*fastqsanger//') # get the basename before R1, a common name for R1 & R2
    #findR2=$(ls $dir_trimmed | grep "${basename}_R2.*\.fastqsanger") # grep for R2 based on R1
    #R2=$dir_trimmed/$findR2 # get R2 file name
    #echo "starting R2 $R2 alignment..."
#    base_output=$(basename "$R" | sed 's/\(.*_R[12]\).*/\1/') # cut off everything after R1 or R2 for downstream naming
#    output_sam="${dir_aligned}/${base_output}.sam" #name sam output 
#    output_bam="${dir_aligned}/${base_output}.bam" #name bam output 
#    output_bam_sorted="${dir_aligned}/${base_output}_sorted.bam" #name sorted bam output 
#    bwa mem -t 4 $ref_genome $R > $output_sam
#    samtools view -bS $output_sam > $output_bam 
#    samtools sort -o $output_bam_sorted $output_bam
#    samtools index $output_bam_sorted
#    rm $output_sam
#    rm $output_bam
#    echo "Mapped $R converted to bam sorted and created $output_bam_sorted and its index."

#done

# samtools statistics with idxstats
#echo "generating statistics for bam files"
#echo "generating statistics for bam files" > "results/bam_statistics.txt"
#for bam_file in $dir_aligned/*.bam; do
#    echo "statistics for $bam_file" >> "results/bam_statistics.txt"
#    samtools idxstats $bam_file >> "results/bam_statistics.txt"
#    echo "clossing statistics for $bam_file" >> "results/bam_statistics.txt"

#done

# finding coverage with multibamsummary
#echo "coverage calculations with multiBamSummary..."
#multiBamSummary bins --bamfiles $dir_aligned/*.bam --binSize 1000 -o "results/multiBamSummary.npz" 

# plot the bam file correlation
#echo "plotting bam file correlation..."
#plotCorrelation -in "results/multiBamSummary.npz"  -c spearman -p heatmap --plotNumbers -o "results/coverage_correlation.png"

# plotting the ChIP-Seq signal strenght
#echo "plotting ChIP-Seq signal strenght"
#plotFingerprint -b $dir_aligned/*G1E*.bam --binSize 100 --skipZeros -plot "results/G1E_signal_strenght.png"
#plotFingerprint -b $dir_aligned/*Megakaryocyte*.bam --binSize 100 --skipZeros -plot "results/Megakaryocyte_G1E_signal_strenght.png"

# G1E peak calling with macs3
##conda activate macs3env
dir_macs3="results/macs3"
#mkdir -p $dir_macs3
#echo "G1E starting peack calling with macs3"
#macs3 callpeak -t $dir_aligned/*G1E_Tal1*.bam -c $dir_aligned/*G1E_input*.bam -f BAM -g mm -n G1E --outdir results/macs3 --bdg --keep-dup auto --call-summits  
#echo "completed macs3 peak calling for G1E"
#echo "Megakaryocyte starting peack calling with macs3"
#macs3 callpeak -t $dir_aligned/*Megakaryocytes_Tal1*.bam -c $dir_aligned/*Megakaryocyte_input*.bam -f BAM -g mm -n Megakaryocyte --outdir results/macs3 --bdg --keep-dup auto --call-summits  
#echo "completed macs3 peak calling for Megakaryocyte"

# find peaks common to each cell type
#echo "intersecting peaks..."
#bedtools intersect -a $dir_macs3/G1E_summits.bed -b $dir_macs3/Megakaryocyte_summits.bed > $ir_macs3/Tal1_common_summits.bed
#bedtools intersect -a $dir_macs3/G1E_summits.bed -b $dir_macs3/Megakaryocyte_summits.bed -v > $dir_macs3/Tal1_G1E_unique_summits.bed
#bedtools intersect -a $dir_macs3/Megakaryocyte_summits.bed -b $dir_macs3/G1E_summits.bed -v > $dir_macs3/Tal1_Megakaryocyte_unique_summits.bed
# sort the bed files output
#sort -k1,1 -k2,2n $dir_macs3/Tal1_G1E_unique_summits.bed > $dir_macs3/sorted_TAL1_G1E_unique_summits.bed
#sort -k1,1 -k2,2n $dir_macs3/Tal1_Megakaryocyte_unique_summits.bed > $dir_macs3/sorted_Tal1_Megakaryocyte_unique_summits.bed
#rm $dir_macs3/Tal1_G1E_unique_summits.bed
#rm $dir_macs3/Tal1_Megakaryocyte_unique_summits.bed

# generate log2ration normalized coverage to compare the bam files
dir_bamcompare="results/bamCompare"
#mkdir -p $dir_bamcompare
#bamCompare -b1 $dir_aligned/Megakaryocytes_Tal1_R1_sorted.bam -b2 $dir_aligned/Megakaryocyte_input_R1_sorted.bam -o $dir_bamcompare/megakaryocyte_TAL1vsInput_R1_log2ratio.bw 
#bamCompare -b1 $dir_aligned/Megakaryocytes_Tal1_R2_sorted.bam -b2 $dir_aligned/Megakaryocyte_input_R2_sorted.bam -o $dir_bamcompare/megakaryocyte_TAL1vsInput_R2_log2ratio.bw 
#bamCompare -b1 $dir_aligned/G1E_Tal1_R1_sorted.bam -b2 $dir_aligned/G1E_input_R1_sorted.bam -o $dir_bamcompare/G1E_TAL1vsInput_R1_log2ratio.bw 
#bamCompare -b1 $dir_aligned/G1E_Tal1_R2_sorted.bam -b2 $dir_aligned/G1E_input_R2_sorted.bam -o $dir_bamcompare/G1E_TAL1vsInput_R2_log2ratio.bw 

# compute matrix for narrow peaks (macs3) bigwig (bamcompare) files
#echo "computing matrix signals on different regions for G1E from bigwig coverage"
#computeMatrix reference-point -R $dir_macs3/G1E_summits.bed \
#    -S $dir_bamcompare/G1E_TAL1vsInput_R1_log2ratio.bw $dir_bamcompare/G1E_TAL1vsInput_R2_log2ratio.bw \
#    --referencePoint center \
#    --upstream 5000 \
#    --downstream 5000 \
#    --skipZeros \
#    --missingDataAsZero \
#    -o results/G1E_matrix_macs3_bigwig.gz

#echo "computing matrix signals on different regions for Megakaryocyte from bigwig coverage"
#computeMatrix reference-point -R $dir_macs3/Megakaryocyte_summits.bed \
#    -S $dir_bamcompare/megakaryocyte_TAL1vsInput_R1_log2ratio.bw $dir_bamcompare/megakaryocyte_TAL1vsInput_R2_log2ratio.bw \
#    --referencePoint center \
#    --upstream 5000 \
#    --downstream 5000 \
#    --skipZeros \
#    --missingDataAsZero \
#    -o results/Megakaryocyte_matrix_macs3_bigwig.gz

# plot the computematrix output signals
 

echo "heatmap for Megakaryocyte signal score distributions accros TAL1 peak genomic regions"
plotHeatmap -m results/Megakaryocyte_matrix_macs3_bigwig.gz \
  -out results/Megakaryocyte_TAL1_heatmap.png \
  --samplesLabel "Megakaryocyte_R1" "Megakaryocyte_R2" \
  --colorMap RdBu \
  --sortRegions descend \
  --plotTitle "TAL1 Peak Distribution in Megakaryocyte Cells" 
