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

### Outputs

| Name | Type | Description |
| ---- | ---- | ----------- |
| `out_metrics_db` | `File` | sqlite file containing metrics data |
| `out_star_result` | `star_results[]` | array of files output by STAR |
| `out_genome_bam` | `File` | the final genome aligned bam |

## GDC Users

The entrypoint CWL workflow for GDC users is
`workflows/star2pass.rnaseq_harmonization.cwl`.
