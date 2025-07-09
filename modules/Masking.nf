#!/usr/bin/env nextflow

process Calling {

    conda 'tb_variant_filter'


    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".fixed.vcf")) {"${sampleName}.fixed.vcf"}}



    input:
        val sampleName
        path called_low_vcf
        path called_unfixed_vcf
        path called_fixed_vcf

    output:
        path "${masked_low_vcf}.masked.snp.vcf", emit: masked_low_vcf
        path "${masked_unfixed_vcf}.masked.vSNPs.vcf", emit: masked_unfixed_vcf
        path "${masked_fixed_vcf}.masked.fSNPs.vcf", emit: masked_fixed_vcf

    script:
    """
    tb_variant_filter -R pe_ppe ${called_low_vcf} ${masked_low_vcf}.masked.snp.vcf
    tb_variant_filter -R pe_ppe ${called_unfixed_vcf} ${masked_unfixed_vcf}.masked.vSNPs.vcf
    tb_variant_filter -R pe_ppe ${called_fixed_vcf} ${masked_fixed_vcf}.fixed.vcf
    """

}
