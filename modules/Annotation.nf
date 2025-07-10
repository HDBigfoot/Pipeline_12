#!/usr/bin/env nextflow

process Annotation {

    publishDir params.outdir + "/Annotation", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".ann.low.vcf")) {"${sampleName}.ann.low.vcf"}
                                                             else if (filename.endsWith(".ann.unfixed.vcf")) {"${sampleName}.ann.unfixed.vcf"}
                                                             else if (filename.endsWith(".ann.fixed.vcf")) {"${sampleName}.ann.fixed.vcf"}}

    input:
        val sampleName
        path low_vcf
        path unfixed_vcf
        path fixed_vcf

    output:
        path "${low_vcf}.ann.low.vcf", emit: ann_low_vcf
        path "${unfixed_vcf}.ann.unfixed.vcf", emit: ann_unfixed_vcf
        path "${fixed_vcf}.ann.fixed.vcf", emit: ann_fixed_vcf

    script:
    """
    sed 's/NC_000962.3/Chromosome/' ${low_vcf} > ${low_vcf}.chr.low.vcf
    sed 's/NC_000962.3/Chromosome/' ${unfixed_vcf} > ${unfixed_vcf}.chr.unfixed.vcf
    sed 's/NC_000962.3/Chromosome/' ${fixed_vcf} > ${fixed_vcf}.chr.fixed.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${low_vcf}.chr.low.vcf > ${low_vcf}.ann.low.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${unfixed_vcf}.chr.unfixed.vcf > ${unfixed_vcf}.ann.unfixed.vcf
    java -jar ${projectDir}/snpEff/snpEff.jar -v Mycobacterium_tuberculosis_h37rv ${fixed_vcf}.chr.fixed.vcf > ${fixed_vcf}.ann.fixed.vcf
    """

}
