#!/usr/bin/env nextflow

process Calling {

    conda 'gatk4'

    /*
     *publishDir params.outdir + "/Calling", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".vcf")) {"${sampleName}_raw.snps.indels.vcf"}
     *                                                             else if (filename.endsWith(".idx")) {"${sampleName}_raw.snps.indels.vcf.idx"}}
     *
     */

    input:
        val sampleName
        path bam_processed
        path ref
        path ref_index
        path ref_dict

    output:
        path "${bam_processed}_raw.snps.indels.vcf", emit: called_vcf
        path "${bam_processed}_raw.snps.indels.vcf.idx", emit: called_idx

    script:
    """
    gatk HaplotypeCaller --sample-ploidy 1 --R ${ref} --I ${bam_processed} --O ${bam_processed}_raw.snps.indels.vcf --max-assembly-region-size 600 --standard-min-confidence-threshold-for-calling 30.0 --min-assembly-region-size 300
    """

}
