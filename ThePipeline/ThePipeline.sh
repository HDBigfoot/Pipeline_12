#!/bin/bash

varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 3 --min-coverage 3 --min-freq-for-hom 0.9 --min-var-freq 0.05 > ${STANDARD_PATH}/Called/${i}.snp.vcf
varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 6 --min-coverage 10 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.1 >  ${STANDARD_PATH}/Called/${i}.vSNPs.vcf
varscan mpileup2snp ${STANDARD_PATH}/Called/${i}.mpileup --p-value 0.01 --min-reads2 20 --min-coverage 20 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.9 > ${STANDARD_PATH}/Called/${i}.fSNPs.vcf
