#!/usr/bin/env nextflow

params.sample_name = "Sample"
params.outdir = "Results"
params.ref = "${projectDir}/Reference/NC_000962.3.fasta"
params.ref_index = "${projectDir}/Reference/NC_000962.3.fasta.fai"
params.ref_dict = "${projectDir}/Reference/NC_000962.3.dict"
params.mask = "${projectDir}/Reference/Farhat_RLC_Regions.bed"
params.mask_index = "${projectDir}/Reference/Farhat_RLC_Regions.bed.idx"

log.info """
Pipeline_12 - Analysis pipeline for detecting unfixed variants in Mycobacterium tuberculosis
RC3ID
Universitas Padjadjaran
================================
sample     : $params.sample_name
reads      : $params.raw_read1 & $params.raw_read2
outdir     : $params.outdir
================================
"""

include { Trimming } from './modules/Trimming.nf'
include { Mapping } from './modules/Mapping.nf'
include { Dedup } from './modules/Dedup.nf'
include { Calling } from './modules/Calling.nf'
include { Filtering } from './modules/Filtering.nf'
include { Annotation } from './modules/Annotation.nf'
include { FastaConversion } from './modules/FastaConversion.nf'

workflow {

    ref_file = file(params.ref)
    ref_index_file = file(params.ref_index)
    ref_dict_file = file(params.ref_dict)

    mask_file = file(params.mask)
    mask_index_file = file(params.mask_index)

    sampleName_ch = Channel.of(params.sample_name)
    rawRead1_ch = Channel.fromPath(params.raw_read1)
    rawRead2_ch = Channel.fromPath(params.raw_read2)

    Trimming(sampleName_ch, rawRead1_ch, rawRead2_ch)
    Mapping(sampleName_ch, Trimming.out.fastp_R1, Trimming.out.fastp_R2, ref_file, ref_index_file, ref_dict_file)
    Dedup(sampleName_ch, Mapping.out.bwa_aligned, ref_file, ref_index_file, ref_dict_file)
    Calling(sampleName_ch, Dedup.out.bam_processed, ref_file, ref_index_file, ref_dict_file)
    Filtering(sampleName_ch, Calling.out.called_low_vcf, Calling.out.called_unfixed_vcf, Calling.out.called_fixed_vcf, ref_file, ref_index_file, ref_dict_file, mask_file, mask_index_file)
    Annotation(sampleName_ch, Filtering.out.low_vcf, Filtering.out.unfixed_vcf, Filtering.out.fixed_vcf)
    FastaConversion(sampleName_ch, Filtering.out.fixed_vcf, Filtering.out.fixed_idx, ref_file, ref_index_file, ref_dict_file)

}
