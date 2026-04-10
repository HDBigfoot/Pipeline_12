#!/usr/bin/env nextflow

process FastaConversion {

    conda 'gatk4'

    publishDir params.outdir + "/FASTA", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".fixed.fasta")) {"${sampleName}.fasta"}
                                                               else if (filename.endsWith(".unfixed.fasta")) {"${sampleName}.unfixed.fasta"}}

    input:
        val sampleName
        path fixed_vcf
        path fixed_index
        path unfixed_vcf
        path unfixed_idx
        path ref
        path ref_index
        path ref_dict

    output:
        path "${fixed_vcf}.fixed.fasta"
        path "${unfixed_vcf}.unfixed.fasta"

    script:
    """
    gatk FastaAlternateReferenceMaker --R ${ref} --V ${fixed_vcf} --O ${fixed_vcf}.raw.fixed.fasta
    sed 's/1 NC_000962.3:1-4411532/'${sampleName}'/' ${fixed_vcf}.raw.fixed.fasta > ${fixed_vcf}.fixed.fasta
    gatk FastaAlternateReferenceMaker --R ${ref} --V ${unfixed_vcf} --O ${unfixed_vcf}.raw.unfixed.fasta
    sed 's/1 NC_000962.3:1-4411532/'${sampleName}'/' ${unfixed_vcf}.raw.unfixed.fasta > ${unfixed_vcf}.unfixed.fasta
    """

}
