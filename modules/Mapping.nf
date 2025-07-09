#!/usr/bin/env nextflow

process Mapping {

    conda 'bwa'

    //publishDir params.outdir + "/Aligned", mode: 'copy', saveAs: { filename -> "${sampleName}_aligned.sam"}

    input:
        val sampleName
        path fastp_R1
        path fastp_R2
        path ref
        path ref_index
        path ref_dict

    output:
        path "${fastp_R1}_aligned.sam", emit: bwa_aligned

    script:
    """
    bwa index ${ref}
    bwa mem -M ${ref} ${fastp_R1} ${fastp_R2} > ${fastp_R1}_aligned.sam
    """

}
