#!/usr/bin/env nextflow

process FastaConversion {

    conda 'gatk4'

    publishDir params.outdir + "/FASTA", mode: 'copy', saveAs: { filename -> "${sampleName}.fasta"}

    input:
        val sampleName
        path fixed_vcf
        path fixed_index
        path ref
        path ref_index
        path ref_dict

    output:
        path "${masked_fixed_vcf}_clean.fasta"

    script:
    """
    gatk FastaAlternateReferenceMaker --R ${ref} --V ${fixed_vcf} --O ${masked_fixed_vcf}_raw.fasta
    sed 's/1 NC_000962.3:1-4411532/'${sampleName}'/' ${fixed_vcf}_raw.fasta > ${fixed_vcf}_clean.fasta
    """

}
