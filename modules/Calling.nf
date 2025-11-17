#!/usr/bin/env nextflow

process Calling {

    conda 'samtools varscan'


    publishDir params.outdir + "/Calling", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".snp.vcf")) {"${sampleName}.snp.vcf"}
                                                                 else if (filename.endsWith(".vSNPs.vcf")) {"${sampleName}.vSNPs.vcf"}
                                                                 else if (filename.endsWith(".fSNPs.vcf")) {"${sampleName}.fSNPs.vcf"}}



    input:
        val sampleName
        path bam_processed
        path ref
        path ref_index
        path ref_dict

    output:
        path "${bam_processed}.snp.vcf", emit: called_low_vcf
        path "${bam_processed}.vSNPs.vcf", emit: called_unfixed_vcf
        path "${bam_processed}.fSNPs.vcf", emit: called_fixed_vcf

    script:
    """
    samtools mpileup -q 30 -Q 20 -AB -f ${ref} ${bam_processed} > ${bam_processed}.mpileup
    varscan mpileup2snp ${bam_processed}.mpileup --p-value 0.01 --min-reads2 3 --min-coverage 3 --min-freq-for-hom 0.9 --min-var-freq 0.05 --output-vcf 1 > ${bam_processed}.snp.raw.vcf
    varscan mpileup2snp ${bam_processed}.mpileup --p-value 0.01 --min-reads2 6 --min-coverage 10 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.1 --output-vcf 1 >  ${bam_processed}.vSNPs.raw.vcf
    varscan mpileup2snp ${bam_processed}.mpileup --p-value 0.01 --min-reads2 20 --min-coverage 20 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.9 --output-vcf 1 > ${bam_processed}.fSNPs.raw.vcf
    sed 's/Sample1/'${sampleName}'/' ${bam_processed}.snp.raw.vcf > ${bam_processed}.snp.vcf
    sed 's/Sample1/'${sampleName}'/' ${bam_processed}.vSNPs.raw.vcf > ${bam_processed}.vSNPs.vcf
    sed 's/Sample1/'${sampleName}'/' ${bam_processed}.fSNPs.raw.vcf > ${bam_processed}.fSNPs.vcf
    """

}
