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
        path "${called_low}.snp.vcf", emit: called_low_vcf
        path "${called_unfixed}.vSNPs.vcf", emit: called_unfixed_vcf
        path "${called_fixed}.fSNPs.vcf", emit: called_fixed_vcf

    script:
    """
    samtools mpileup -q 30 -Q 20 -AB -f ${ref} ${bam_processed} > ${mpileup}.mpileup
    varscan mpileup2snp ${mpileup}.mpileup --p-value 0.01 --min-reads2 3 --min-coverage 3 --min-freq-for-hom 0.9 --min-var-freq 0.05 --output-vcf 1 > ${called_low}.snp.vcf
    varscan mpileup2snp ${mpileup}.mpileup --p-value 0.01 --min-reads2 6 --min-coverage 10 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.1 --output-vcf 1 >  ${called_unfixed}.vSNPs.vcf
    varscan mpileup2snp ${mpileup}.mpileup --p-value 0.01 --min-reads2 20 --min-coverage 20 --min-avg-qual 25 --min-strands2 2 --min-var-freq 0.9 --output-vcf 1 > ${called_fixed}.fSNPs.vcf
    """

}
