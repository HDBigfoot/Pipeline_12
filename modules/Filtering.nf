#!/usr/bin/env nextflow

process Filtering {

    conda 'gatk4'

    publishDir params.outdir + "/VCF", mode: 'copy', saveAs: {filename -> if (filename.endsWith(".low.vcf")) {"${sampleName}.low.vcf"}
                                                             else if (filename.endsWith(".low.vcf.idx")) {"${sampleName}.low.vcf.idx"}
                                                             else if (filename.endsWith(".unfixed.vcf")) {"${sampleName}.unfixed.vcf"}
                                                             else if (filename.endsWith(".unfixed.vcf.idx")) {"${sampleName}.unfixed.vcf.idx"}
                                                             else if (filename.endsWith(".fixed.vcf")) {"${sampleName}.fixed.vcf"}
                                                             else if (filename.endsWith(".fixed.vcf.idx")) {"${sampleName}.fixed.vcf.idx"}}

    input:
        val sampleName
        path called_low_vcf
        path called_unfixed_vcf
        path called_fixed_vcf
        path ref
        path ref_index
        path ref_dict
        path mask
        path mask_index

    output:
        path "${called_low_vcf}.low.vcf", emit: low_vcf
        path "${called_low_vcf}.low.vcf.idx", emit: low_idx
        path "${called_unfixed_vcf}.unfixed.vcf", emit: unfixed_vcf
        path "${called_unfixed_vcf}.unfixed.vcf.idx", emit: unfixed_idx
        path "${called_fixed_vcf}.fixed.vcf", emit: fixed_vcf
        path "${called_fixed_vcf}.fixed.vcf.idx", emit: fixed_idx

    script:
    """
    gatk VariantFiltration --R ${ref} --V ${called_low_vcf} --mask ${mask} --filter-expression "HOM > 0" --filter-name "FAILED" --O ${called_low_vcf}.flagged.snp.vcf
    gatk SelectVariants --R ${ref} --V ${called_low_vcf}.flagged.snp.vcf --exclude-filtered --O ${called_low_vcf}.low.vcf
    gatk VariantFiltration --R ${ref} --V ${called_unfixed_vcf} --mask ${mask} --filter-expression "HOM > 0" --filter-name "FAILED" --O ${called_unfixed_vcf}.flagged.vSNPs.vcf
    gatk SelectVariants --R ${ref} --V ${called_unfixed_vcf}.flagged.vSNPs.vcf --exclude-filtered --O ${called_unfixed_vcf}.unfixed.vcf
    gatk VariantFiltration -R ${ref} --V ${called_fixed_vcf} --mask ${mask} --O ${called_fixed_vcf}.flagged.fSNPs.vcf
    gatk SelectVariants -R ${ref} --V ${called_fixed_vcf}.flagged.fSNPs.vcf --exclude-filtered --O ${called_fixed_vcf}.fixed.vcf
    """

}
