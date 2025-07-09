#!/bin/bash

SNP_EFF_PATH="/home/tbwg/Documents/BioInfoProjects/Pipeline_12/snpEff"
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
    samtools mpileup -q 30 -Q 20 -AB -f /Storage/Reference/PhenixReference/NC_000962.3.fasta ${STANDARD_PATH}/Dedup/${i}_dedup.bam > ${STANDARD_PATH}/Called/${i}.mpileup
    varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 3 --min-coverage 3 --min-freq-for-hom 0.9 --min-var-freq 0.05 --output-vcf 1 > ${STANDARD_PATH}/Called/${i}.snp.vcf
    varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 6 --min-coverage 10 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.1 --output-vcf 1 >  ${STANDARD_PATH}/Called/${i}.vSNPs.vcf
    varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 20 --min-coverage 20 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.9 --output-vcf 1 > ${STANDARD_PATH}/Called/${i}.fSNPs.vcf
    tb_variant_filter -R pe_ppe ${STANDARD_PATH}/Called/${i}.snp.vcf ${STANDARD_PATH}/Called/${i}.masked.snp.vcf
    tb_variant_filter -R pe_ppe ${STANDARD_PATH}/Called/${i}.vSNPs.vcf ${STANDARD_PATH}/Called/${i}.masked.vSNPs.vcf
    tb_variant_filter -R pe_ppe ${STANDARD_PATH}/Called/${i}.fSNPs.vcf ${STANDARD_PATH}/VCF/${i}.fixed.vcf
    gatk VariantFiltration --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}.masked.snp.vcf --filter-expression "HOM > 0" --filter-name "FAILED" --O ${STANDARD_PATH}/Called/${i}.flagged.het.snp.vcf
    gatk SelectVariants --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}.flagged.het.snp.vcf --exclude-filtered --O ${STANDARD_PATH}/VCF/${i}.low.vcf
    gatk VariantFiltration --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}.masked.vSNPs.vcf --filter-expression "HOM > 0" --filter-name "FAILED" --O ${STANDARD_PATH}/Called/${i}.flagged.het.vSNPs.vcf
    gatk SelectVariants --R /Storage/Reference/PhenixReference/NC_000962.3.fasta --V ${STANDARD_PATH}/Called/${i}.flagged.het.vSNPs.vcf --exclude-filtered --O ${STANDARD_PATH}/VCF/${i}.unfixed.vcf
    sed 's/NC_000962.3/Chromosome/' ${STANDARD_PATH}/VCF/${i}.low.vcf > ${STANDARD_PATH}/VCF/${i}.chr.low.vcf
    sed 's/NC_000962.3/Chromosome/' ${STANDARD_PATH}/VCF/${i}.unfixed.vcf > ${STANDARD_PATH}/VCF/${i}.chr.unfixed.vcf
    sed 's/NC_000962.3/Chromosome/' ${STANDARD_PATH}/VCF/${i}.fixed.vcf > ${STANDARD_PATH}/VCF/${i}.chr.fixed.vcf
    mkdir -p ${STANDARD_PATH}/Annotated/Raw/${i}_low
    cd ${STANDARD_PATH}/Annotated/Raw/${i}_low
    java -jar ${SNP_EFF_PATH}/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${STANDARD_PATH}/VCF/${i}.chr.low.vcf > ${i}.ann.low.vcf
    mkdir -p ${STANDARD_PATH}/Annotated/Raw/${i}_unfixed
    cd ${STANDARD_PATH}/Annotated/Raw/${i}_unfixed
    java -jar ${SNP_EFF_PATH}/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${STANDARD_PATH}/VCF/${i}.chr.unfixed.vcf > ${i}.ann.unfixed.vcf
    mkdir -p ${STANDARD_PATH}/Annotated/Raw/${i}_fixed
    cd ${STANDARD_PATH}/Annotated/Raw/${i}_fixed
    java -jar ${SNP_EFF_PATH}/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${STANDARD_PATH}/VCF/${i}.chr.fixed.vcf > ${i}.ann.fixed.vcf
    done
