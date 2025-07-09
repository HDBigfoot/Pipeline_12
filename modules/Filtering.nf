#!/usr/bin/env nextflow

process Filtering {

    conda 'gatk4'

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".low.vcf")) {"${sampleName}.low.vcf"}
                                                             else if (filename.endsWith(".low.vcf.idx")) {"${sampleName}.low.vcf.idx"}
                                                             else if (filename.endsWith(".unfixed.vcf")) {"${sampleName}.unfixed.vcf"}
                                                             else if (filename.endsWith(".unfixed.vcf.idx")) {"${sampleName}.unfixed.vcf.idx"}}

    input:
        val sampleName
        path masked_low_vcf
        path masked_unfixed_vcf
        path ref
        path ref_index
        path ref_dict

    output:
        path "${low_vcf}.low.vcf", emit: low_vcf
        path "${low_vcf}.low.vcf.idx", emit: low_idx
        path "${unfixed_vcf}.unfixed.vcf", emit: unfixed_vcf
        path "${unfixed_vcf}.unfixed.vcf.idx", emit: unfixed_idx

    script:
    """
    gatk VariantFiltration --R ${ref} --V ${masked_low_vcf} --filter-expression "HOM > 0" --filter-name "FAILED" --O ${flagged_low_vcf}.flagged.snp.vcf
    gatk SelectVariants --R ${ref} --V ${flagged_low_vcf}.flagged.snp.vcf --exclude-filtered --O ${low_vcf}.low.vcf
    gatk VariantFiltration --R ${ref} --V ${masked_unfixed_vcf} --filter-expression "HOM > 0" --filter-name "FAILED" --O ${flagged_unfixed_vcf}.flagged.vSNPs.vcf
    gatk SelectVariants --R ${ref} --V ${flagged_unfixed_vcf}.flagged.vSNPs.vcf --exclude-filtered --O ${unfixed_vcf}.unfixed.vcf
    """

}
