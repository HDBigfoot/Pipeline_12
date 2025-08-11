# Pipeline_12

![RC3ID Logo](Logo/Pusris.jpg)

This is a bioinformatics pipeline for analyzing unfixed variants in Mycobacterium tuberculosis.

This pipeline is modified from the following repositories:

https://gitlab.com/tbgenomicsunit/ThePipeline
https://github.com/MtbEvolution/resR_Project

### Requirements

- **Conda**
- **Nextflow**
- **R**

## Installation

Clone this repository:

```bash
git clone https://github.com/HDBigfoot/Pipeline_12.git
```

## Usage

Running main pipeline:

```bash
nextflow run /PATH/TO/PROJECT/Pipeline_12/Pipeline_12-main.nf --raw_read1 /PATH/TO/RAW/READS/<sample_name>_1.fastq.gz --raw_read2 /PATH/TO/RAW/READS/<sample_name>_2.fastq.gz --sample_name <sample_name> --outdir <outdir>
```
## References

ThePipeline:
> Bermudez-Hernández, G.A., Pérez-Martínez, D.E., Madrazo-Moya, C.F. et al. Whole genome sequencing analysis to evaluate the influence of T2DM on polymorphisms associated with drug resistance in M. tuberculosis. BMC Genomics 23, 465 (2022). <https://doi.org/10.1186/s12864-022-08709-z>

resR:
> Qingyun Liu et al., Tuberculosis treatment failure associated with evolution of antibiotic resilience. Science 378,1111-1118(2022). <https://doi.org/10.1126/science.abq2787>

Nextflow:
> Di Tommaso, P., Chatzou, M., Floden, E. et al. Nextflow enables reproducible computational workflows. Nat Biotechnol 35, 316–319 (2017). <https://doi.org/10.1038/nbt.3820>

### Main Pipeline

fastp
> Shifu Chen, Yanqing Zhou, Yaru Chen, Jia Gu, fastp: an ultra-fast all-in-one FASTQ preprocessor, Bioinformatics, Volume 34, Issue 17, September 2018, Pages i884–i890, <https://doi.org/10.1093/bioinformatics/bty560>

bwa-mem
> Li H. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv preprint arXiv:1303.3997. 2013. <https://doi.org/10.48550/arXiv.1303.3997>

gatk4
> Van der Auwera GA, O'Connor BD. Genomics in the Cloud: Using Docker, GATK, and WDL in Terra. 1st ed. O'Reilly Media; 2020.

samtools
> Li H, Handsaker B, Wysoker A, Fennell T, Ruan J, Homer N, Marth G, Abecasis G, Durbin R; 1000 Genome Project Data Processing Subgroup. The Sequence Alignment/Map format and SAMtools. Bioinformatics. 2009 Aug 15;25(16):2078-9. <https://doi.org/10.1093/bioinformatics/btp352>

varscan
> Koboldt DC, Chen K, Wylie T, Larson DE, McLellan MD, Mardis ER, Weinstock GM, Wilson RK, Ding L. VarScan: variant detection in massively parallel sequencing of individual and pooled samples. Bioinformatics. 2009 Sep 1;25(17):2283-5. <https://doi.org/10.1093/bioinformatics/btp373>

Regions masked according to Marin, et al., (2022)
> Maximillian Marin, Roger Vargas, Michael Harris, Brendan Jeffrey, L Elaine Epperson, David Durbin, Michael Strong, Max Salfinger, Zamin Iqbal, Irada Akhundova, Sergo Vashakidze, Valeriu Crudu, Alex Rosenthal, Maha Reda Farhat, Benchmarking the empirical accuracy of short-read sequencing across the M. tuberculosis genome, Bioinformatics, Volume 38, Issue 7, March 2022, Pages 1781–1787, <https://doi.org/10.1093/bioinformatics/btac023>

snpEff
> Cingolani P, Platts A, Wang le L, Coon M, Nguyen T, Wang L, Land SJ, Lu X, Ruden DM. A program for annotating and predicting the effects of single nucleotide polymorphisms, SnpEff: SNPs in the genome of Drosophila melanogaster strain w1118; iso-2; iso-3. Fly (Austin). 2012 Apr-Jun;6(2):80-92. <https://doi.org/10.4161/fly.19695>
