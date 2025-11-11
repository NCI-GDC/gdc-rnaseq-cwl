![Version badge](https://img.shields.io/badge/star-2.7.5c-green.svg)

![Version badge](https://img.shields.io/badge/picard-2.26.10-green.svg)

# GDC RNA-Seq Alignment Workflow

This workflow takes a set of input RNA-Seq short read data as  FASTQ or BAM
files and generates multiple harmonized BAM files, gene counts, and other
datasets.

## External Users

The entrypoint CWL workflow for external users is
`rnaseq-star-align/subworkflows/gdc_rnaseq_main_workflow.cwl`.

The example input json in `rnaseq-star-align/example/main_workflow.example.input.json`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `readgroup_bam_file_list` | `readgroup_bam_file[]` | array of objects containing BAM files and readgroup metadata |
| `readgroup_fastq_file_list` | `readgroup_fastq_file[]` | array of objects containing FASTQ files and readgroup metadata |
| `ref_flat` | `File` | ref flat annotation file |
| `ribosome_intervals` | `File` | interval file containing rRNA locations |
| `star_genome_dir` | `Directory` | the directory containing the STAR index files |
| `gene_info` | `File` | tab-separated file relating gene symbol, biotype, and other info to gene ID |
| `threads` | `int?` | the number of threads to use for multi-threaded tools |
| `job_uuid` | `string` | string used as a prefix for all the output filenames |
| `picard_java_mem` | `int` | amount of memory (Gb) to use for picard (default: 4) |
| `gencode_version` | `string` | string indicating gencode annotation version (default: `v36`) |

**Custom Data Types**

* `readgroup_bam_file` - contains a bam file and an array of `readgroup_meta` objects

| Name | Type | Description |
| ---- | ---- | ----------- |
| `bam` | `File` | input aligned or unaligned bam file |
| `readgroup_meta_list` | `readgroup_meta[]` | array of `readgroup_meta` objects |

* `readgroup_meta` - contains readgroup tags and values

| Name | Type | Description |
| ---- | ---- | ----------- |
| `CN` | `string?` | optional sequencing center |
| `DS` | `string?` | optional description |
| `DT` | `string?` | optional ISO8601 sequencing date |
| `FO` | `string?` | optional flow order array of nocleotide bases that corresponded to the nucleotides used for each flow of each read |
| `ID` | `string` | required read group ID |
| `KS` | `string?` | optional array of nucleotide bases that correspond to the key sequence of each read |
| `LB` | `string?` | optional library ID |
| `PI` | `string?` | optional predicted median insert size |
| `PL` | `string` | required platform |
| `PM` | `string?` | optional platform model |
| `PU` | `string?` | optional platform unit |
| `SM` | `string` | required sample ID |

* `readgroup_fastq_file` - contains single or pair of fastq files and an array of `readgroup_meta` objects

| Name | Type | Description |
| ---- | ---- | ----------- |
| `forward_fastq` | `File` | read1 fastq file |
| `reverse_fastq` | `File?` | optional read2 fastq file if paired library |
| `readgroup_meta_list` | `readgroup_meta[]` | array of `readgroup_meta` objects |

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `out_metrics_db` | `File` | sqlite file containing metrics data |
| `out_gene_counts_file` | `File` | gene-level counts as estimated by STAR |
| `out_junctions_file` | `File` | TSV containing splice junctions detected by STAR |
| `out_transcriptome_bam_file` | `File?` | If there are paired-end reads, the transcriptome alignments are provided in this unsorted bam file |
| `out_chimeric_bam_file` | `File?` | If there are paired-end reads, the chimeric alignments (sorted and indexed) |
| `out_chimeric_tsv_file` | `File?` | If there are paired-end reads, the TSV containing chimeric information for fusion detection |
| `out_genome_bam` | `File` | the final genome aligned bam (sorted and indexed) |
| `out_archive_file` | `File` | `tar.gz` archive containing other outputs from STAR |

## GDC Users

The entrypoint CWL workflow for GDC users is
`rnaseq-star-align/star2pass.rnaseq_harmonization.cwl`. Additionally as a special case can handle a limited set of tar files.

