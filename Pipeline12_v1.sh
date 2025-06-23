#!/bin/bash

STANDARD_PATH="/Storage/Data_DNA/Global_Dataset/Amsterdam/Run01"
File="/Storage/Data_DNA/Global_Dataset/Amsterdam/Amsterdam_list.txt"
Lines=$(cat $File)
for i in $Lines
    do
    fastp -i /Storage/Data_DNA/Global_Dataset/Amsterdam/Amsterdam/${i}_1.fastq.gz -I /Storage/Data_DNA/Global_Dataset/Amsterdam/Amsterdam/${i}_2.fastq.gz -o ${STANDARD_PATH}/Trimmed/${i}_R1_fastp.fastq.gz -O ${STANDARD_PATH}/Trimmed/${i}_R2_fastp.fastq.gz --length_required 50 --html ${STANDARD_PATH}/Trimmed/${i}.fastp.html
    bwa mem -M /Storage/Reference/PhenixReference/NC_000962.3.fasta ${STANDARD_PATH}/Trimmed/${i}_R1_fastp.fastq.gz ${STANDARD_PATH}/Trimmed/${i}_R2_fastp.fastq.gz > ${STANDARD_PATH}/Aligned/${i}_Aligned.sam
    gatk FixMateInformation --ASSUME_SORTED false --I ${STANDARD_PATH}/Aligned/${i}_Aligned.sam --O ${STANDARD_PATH}/Aligned/${i}_fixed.bam
    gatk SortSam --I ${STANDARD_PATH}/Aligned/${i}_fixed.bam --O ${STANDARD_PATH}/Aligned/${i}_sorted.bam --SO coordinate
    gatk AddOrReplaceReadGroups --I ${STANDARD_PATH}/Aligned/${i}_sorted.bam --RGLB lib1 --RGPL illumina --RGPU unit1 --RGSM ${i} --O ${STANDARD_PATH}/Aligned/${i}_rg.bam
    gatk MarkDuplicates --REMOVE_DUPLICATES true --CREATE_INDEX true --ASSUME_SORTED true --I ${STANDARD_PATH}/Aligned/${i}_rg.bam --O ${STANDARD_PATH}/Dedup/${i}_dedup.bam --M ${STANDARD_PATH}/Dedup/${i}_metrics.txt
    gatk HaplotypeCaller --sample-ploidy 1 --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --I ${STANDARD_PATH}/Dedup/${i}_dedup.bam --O ${STANDARD_PATH}/Called/${i}_raw.snps.indels.vcf --max-assembly-region-size 600 --standard-min-confidence-threshold-for-calling 30.0 --min-assembly-region-size 300
    gatk SelectVariants --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}_raw.snps.indels.vcf --select-type-to-include SNP --O ${STANDARD_PATH}/Called/${i}_raw.snps.vcf
    gatk VariantFiltration --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}_raw.snps.vcf --filter-expression "QUAL < 30.0 || QD < 2.0 || FS > 60.0 || MQ < 40.0 || DP < 12" --filter-name "FAILED" --O ${STANDARD_PATH}/Called/${i}_flagged.snps.vcf
    gatk SelectVariants --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}_flagged.snps.vcf --exclude-filtered --O ${STANDARD_PATH}/VCF/${i}.vcf
    gatk FastaAlternateReferenceMaker --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/VCF/${i}.vcf --O ${STANDARD_PATH}/FASTA_Complete/${i}.fasta
    sed 's/1 NC_000962.3:1-4411532/'${i}'/' ${STANDARD_PATH}/FASTA_Complete/${i}.fasta > ${STANDARD_PATH}/FASTA/${i}.fasta
    done
