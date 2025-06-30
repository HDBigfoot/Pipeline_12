#!/bin/bash


STANDARD_PATH="/Storage/Data_DNA/Global_Dataset/Amsterdam/Run01"
File="/Storage/Data_DNA/Global_Dataset/Amsterdam/Amsterdam_list.txt"
Lines=$(cat $File)
for i in $Lines
    do
    samtools mpileup -q 30 -Q 20 -AB -f /Storage/Reference/PhenixReference/NC_000962.3.fasta ${STANDARD_PATH}/Dedup/${i}_dedup.bam > ${STANDARD_PATH}/Called/${i}.mpileup
    varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --min-coverage 3 --min-reads2 2 --min-avg-qual 20 --min-var-freq 0.01 --min-freq-for-hom 0.9 --p-value 99e-02 --strand-filter 1 > ${STANDARD_PATH}/Called/${i}.fixed.snps.vcf
    varscan mpileup2cns ${STANDARD_PATH}/Called/${i}.mpileup --min-coverage 3 --min-avg-qual 20 --min-var-freq 0.75 --min-reads2 2 --strand-filter 1 > ${STANDARD_PATH}/Called/${i}.fixed.cns.vcf
    perl PPE_PE_INS_filt.pl PPE_INS_loci.list ${STANDARD_PATH}/Called/${i}.snps.vcf > ${STANDARD_PATH}/Called/${i}.fixed.snps.masked.vcf
    perl format_trans.pl ${STANDARD_PATH}/Called/${i}.fixed.snps.masked.vcf > ${STANDARD_PATH}/Called/${i}.fixed.snps.formatted.vcf
    perl fix_extract.pl ${STANDARD_PATH}/Called/${i}.fixed.snps.fixed.vcf
    perl unfix_pileup_match.pl ${STANDARD_PATH}/Called/${i}.fixed.snps.formatted.vcf ${STANDARD_PATH}/Called/${i}.mpileup > ${STANDARD_PATH}/Called/${i}.fixed.snps.forup.vcf
    cut -f2-4 ${STANDARD_PATH}/Called/${i}.fixed.snps.fixed.vcf > ${i}.fixed.snps.clean.vcf
    done
