# GDC RNA-Seq Alignment Workflow

This workflow takes a set of input RNA-Seq FASTQ/BAM files and generates
multiple harmonized BAM files, gene counts, and other datasets.

## External Users 

The entrypoint CWL workflow for external users is 
`workflows/subworkflows/gdc_rnaseq_main_workflow.cwl`.

### Inputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `readgroup_bam_file_list` | `readgroup_bam_file[]` | array of objects containing BAM files and readgroup metadata |
| `readgroup_fastq_file_list` | `readgroup_fastq_file[]` | array of objects containing FASTQ files and readgroup metadata |
| `ref_flat` | `File` | ref flat annotation file |
| `ribosome_intervals` | `File` | interval file containing rRNA locations |
| `star_genome_dir` | `Directory` | the directory containing the STAR index files |
| `threads` | `int?` | the number of threads to use for multi-threaded tools |
| `job_uuid` | `string` | string used as a prefix for all the output filenames |
| `picard_java_mem` | `int` | amount of memory (Gb) to use for picard (default: 4) |

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
| `out_star_result` | `star_results[]` | array of files output by STAR |
| `out_genome_bam` | `File` | the final genome aligned bam |

**Custom Data Types**

* `star_results` - object containing files and metadata output by STAR

| Name | Type | Description |
| ---- | ---- | ----------- |
| `star_stats` | `File` | run statistics file output by STAR |
| `star_junctions` | `File` | junction file |
| `star_chimeric_junctions` | `File` | chimeric TSV file |
| `star_gene_counts` | `File` | gene-level counts produced by STAR |
| `star_genome_bam` | `File` | the RNA-Seq genome alignments |
| `star_chimeric_bam` | `File` | the chimeric alignments |
| `star_transcriptome_bam` | `File` | the RNA-Seq transcriptome alignments |
| `archived_other_directories` | `File[]` | list of directory archives containing misc output files |
| `is_paired` | `boolean` | whether the inputs were paired or not |

## GDC Users

The entrypoint CWL workflow for GDC users is
`workflows/star2pass.rnaseq_harmonization.cwl`.
