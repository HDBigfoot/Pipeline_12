# Pipeline_11

![RC3ID Logo](Logos/PusrisLogos.jpg)

This is a bioinformatics pipeline I wrote for the analysis of Mycobacterium tuberculosis genomes for the Research Center for Care and Control of Infectious Diseases (RC3ID) and the Center for Translational Biomarker Research (CentraBioRes), Universitas Padjadjaran.

This pipeline is modified from Mycodentifier (https://github.com/JordyCoolen/MyCodentifier.git)

### Requirements

- **Conda**
- **Nextflow**
- **R**
- **Python**

## Installation

Clone this repository:

```bash
git clone https://github.com/HDBigfoot/Pipeline_11.git
```

## Usage

Running main pipeline:

```bash
nextflow run /PATH/TO/PROJECT/Pipeline_11/Pipeline_11-main.nf --raw_read1 /PATH/TO/RAW/READS/<sample_name>_1.fastq.gz --raw_read2 /PATH/TO/RAW/READS/<sample_name>_2.fastq.gz --sample_name <sample_name>
```

Combining and masking FASTAs:

```bash
nextflow run /PATH/TO/PROJECT/Pipeline_11/CombineAndMask.nf --sample_list <list-of-samples>.txt --inputdir /PATH/TO/FASTA/FILES/ --project_name <project_name>
```

Running SNP-Distance Analysis:

```bash
nextflow run /PATH/TO/PROJECT/Pipeline_11/SnpDistance.nf --input_fasta /PATH/TO/COMBINED/FASTA/<combined_fasta>.masked.fasta --project_name <project_name>
```

## References

MyCodentifier:
> Schildkraut JA, Coolen JPM, Severin H, Koenraad E, Aalders N, Melchers WJG, et al. MGIT Enriched Shotgun Metagenomics for Routine Identification of Nontuberculous Mycobacteria: a Route to Personalized Health Care. J Clin Microbiol. 2023 Mar 23;61(3):e0131822. <https://doi.org/10.1128/jcm.01318-22>

Nextflow:
> Di Tommaso, P., Chatzou, M., Floden, E. et al. Nextflow enables reproducible computational workflows. Nat Biotechnol 35, 316–319 (2017). <https://doi.org/10.1038/nbt.3820>

### Main Pipeline

fastp
> Shifu Chen, Yanqing Zhou, Yaru Chen, Jia Gu, fastp: an ultra-fast all-in-one FASTQ preprocessor, Bioinformatics, Volume 34, Issue 17, September 2018, Pages i884–i890, <https://doi.org/10.1093/bioinformatics/bty560>

bwa-mem
> Li H. Aligning sequence reads, clone sequences and assembly contigs with BWA-MEM. arXiv preprint arXiv:1303.3997. 2013. <https://doi.org/10.48550/arXiv.1303.3997>

gatk4
> Van der Auwera GA, O'Connor BD. Genomics in the Cloud: Using Docker, GATK, and WDL in Terra. 1st ed. O'Reilly Media; 2020.

### Masking Fasta

Code for masking fastas was provided by Dr. Philip Ashton, regions masked as per (Holt, et al., 2018):
> Holt, K.E., McAdam, P., Thai, P.V.K. et al. Frequent transmission of the Mycobacterium tuberculosis Beijing lineage and positive selection for the EsxW Beijing variant in Vietnam. Nat Genet 50, 849–856 (2018). <https://doi.org/10.1038/s41588-018-0117-9>

Seqkit
> Shen W, Sipos B, Zhao L. SeqKit2: A Swiss army knife for sequence and alignment processing. iMeta. 2024;3(3):191. <https://doi.org/10.1002/imt2.191.>

Bedtools
> Aaron R. Quinlan, Ira M. Hall, BEDTools: a flexible suite of utilities for comparing genomic features, Bioinformatics, Volume 26, Issue 6, March 2010, Pages 841–842, <https://doi.org/10.1093/bioinformatics/btq033>

### SNP-Distance Analysis

snp-dists
> https://github.com/tseemann/snp-dists.git
