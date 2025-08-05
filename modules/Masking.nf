#!/usr/bin/env nextflow

process Masking {

    conda 'tb_variant_filter'


    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".fixed.vcf")) {"${sampleName}.fixed.vcf"}}



    input:
        val sampleName
        path called_low_vcf
        path called_unfixed_vcf
        path called_fixed_vcf

    output:
        path "${called_low_vcf}.masked.snp.vcf", emit: masked_low_vcf
        path "${called_unfixed_vcf}.masked.vSNPs.vcf", emit: masked_unfixed_vcf
        path "${called_fixed_vcf}.fixed.vcf", emit: masked_fixed_vcf

    script:
    """
    tb_variant_filter -R farhat_rlc ${called_low_vcf} ${called_low_vcf}.masked.snp.vcf
    tb_variant_filter -R farhat_rlc ${called_unfixed_vcf} ${called_unfixed_vcf}.masked.vSNPs.vcf
    tb_variant_filter -R farhat_rlc ${called_fixed_vcf} ${called_fixed_vcf}.fixed.vcf
    """

}
