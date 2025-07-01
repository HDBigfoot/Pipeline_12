#!/bin/bash

varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --min-coverage 3 --min-reads2 2 --min-avg-qual 20 --min-var-freq 0.01 --min-freq-for-hom 0.9 --p-value 99e-02 --strand-filter 1 > ${STANDARD_PATH}/Called/${i}.unfixed.snps.vcf
varscan mpileup2cns ${STANDARD_PATH}/Called/${i}.mpileup --min-coverage 3 --min-avg-qual 20 --min-var-freq 0.75 --min-reads2 2 --strand-filter 1 > ${STANDARD_PATH}/Called/${i}.unfixed.cns.vcf
perl PE_IS_filt.pl Excluded_loci_mask.list ${STANDARD_PATH}/Called/${i}.unfixed.snps.vcf > ${STANDARD_PATH}/Called/${i}.unfixed.snps.masked.vcf
perl format_trans.pl ${STANDARD_PATH}/Called/${i}.unfixed.snps.masked.vcf > ${STANDARD_PATH}/Called/${i}.unfixed.snps.formatted.vcf
perl mix_pileup_merge.pl ${STANDARD_PATH}/Called/${i}.unfixed.snps.formatted.vcf ${STANDARD_PATH}/Called/${i}.mpileup > ${STANDARD_PATH}/Called/${i}.unfixed.snps.forup.vcf
sed 's/:/\t/g' ${STANDARD_PATH}/Called/${i}.unfixed.cns.vcf|awk '{if (\$6 >= 3){n++;sum+=\$6}} END {print \"\t\",n/4411532,\"\t\",sum/n}' > ${STANDARD_PATH}/Called/${i}.unfixed.cns.dep.vcf
perl mix_extract_0.95.pl ${STANDARD_PATH}/Called/${i}.unfixed.snps.forup.vcf > ${STANDARD_PATH}/Called/${i}.unfixed.snps.mix.vcf

