#!/usr/bin/env nextflow

process Trimming {

    conda 'fastp'


    publishDir params.outdir + "/Trimming", mode: 'copy', saveAs: { filename -> if (filename.endsWith("1_fastp.fastq.gz")) {"${sampleName}_1_fastp.fastq.gz"}
                                                                   else if (filename.endsWith("2_fastp.fastq.gz")) {"${sampleName}_2_fastp.fastq.gz"}
                                                                   else if (filename.endsWith("html")) {"${sampleName}.fastp.html"}}


    input:
        val sampleName
        path rawRead1
        path rawRead2

    output:
        path "${rawRead1}_fastp.fastq.gz", emit: fastp_R1
        path "${rawRead2}_fastp.fastq.gz", emit: fastp_R2
        path "${rawRead1}.fastp.html"

    script:
    """
    fastp -i ${rawRead1} -I ${rawRead2} -o ${rawRead1}_fastp.fastq.gz -O ${rawRead2}_fastp.fastq.gz --length_required 50 --html ${rawRead1}.fastp.html
    """

}
