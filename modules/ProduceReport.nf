#!/usr/bin/env nextflow

process ProduceReport {

    conda 'tbvcfreport'

    publishDir params.outdir + "/tbvcfreport", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".low_variants_report.html")) {"${sampleName}.low.report.html"}
                                                             else if (filename.endsWith(".low_variants_report.txt")) {"${sampleName}.low.report.txt"}
                                                             else if (filename.endsWith(".unfixed_variants_report.html")) {"${sampleName}.unfixed.report.html"}
                                                             else if (filename.endsWith(".unfixed_variants_report.txt")) {"${sampleName}.unfixed.report.txt"}
                                                             else if (filename.endsWith(".fixed_variants_report.html")) {"${sampleName}.fixed.report.html"}
                                                             else if (filename.endsWith(".fixed_variants_report.txt")) {"${sampleName}.fixed.report.txt"}}

    input:
        val sampleName
        path ann_low_vcf
        path ann_unfixed_vcf
        path ann_fixed_vcf

    output:
        path "${ann_low_vcf}_variants_report.html", emit: low_html_report
        path "${ann_low_vcf}_variants_report.txt", emit: low_report
        path "${ann_unfixed_vcf}_variants_report.html", emit: unfixed_html_report
        path "${ann_unfixed_vcf}_variants_report.txt", emit: unfixed_report
        path "${ann_fixed_vcf}_variants_report.html", emit: fixed_html_report
        path "${ann_fixed_vcf}_variants_report.txt", emit: fixed_report

    script:
    """
    tbvcfreport generate ${ann_low_vcf}
    tbvcfreport generate ${ann_unfixed_vcf}
    tbvcfreport generate ${ann_fixed_vcf}
    """

}
