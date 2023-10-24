cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_star2pass_wf
requirements:
  - class: SubworkflowFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../tools/readgroup.cwl
      - $import: ../tools/star_results.cwl

inputs:
  bioclient_config: File
  upload_bucket: string
  threads: int?
  job_uuid: string
  ribosome_intervals_uuid: string
  ref_flat_uuid: string
  star_index_archive_uuid: string
  readgroup_fastq_uuid_list:
    type:
      type: array
      items: ../tools/readgroup.cwl#readgroup_fastq_uuid
  readgroup_bam_uuid_list:
    type:
      type: array
      items: ../tools/readgroup.cwl#readgroup_bam_uuid
  sample_tarball_uuid_list:
    type:
      type: array
      items: ../tools/readgroup.cwl#sample_tarball_uuid
    default: []
  picard_java_mem:
    type: int
    default: 4
  gencode_version: string
  gene_info_uuid: string

outputs:
  harmonization_metrics_uuid:
    type: string
    outputSource: load_outputs/metrics_db_uuid

  star_genomic_bam_uuid:
    type: string
    outputSource: load_outputs/genomic_bam_uuid

  star_genomic_bai_uuid:
    type: string
    outputSource: load_outputs/genomic_bai_uuid

  star_transcriptome_bam_uuid:
    type: string?
    outputSource: load_outputs/transcriptome_bam_uuid

  star_chimeric_bam_uuid:
    type: string?
    outputSource: load_outputs/chimeric_bam_uuid

  star_chimeric_bai_uuid:
    type: string?
    outputSource: load_outputs/chimeric_bai_uuid

  star_chimeric_tsv_uuid:
    type: string?
    outputSource: load_outputs/chimeric_tsv_uuid

  star_gene_counts_uuid:
    type: string
    outputSource: load_outputs/gene_counts_uuid

  star_junctions_tsv_uuid:
    type: string
    outputSource: load_outputs/junctions_tsv_uuid

  star_archive_uuid:
    type: string
    outputSource: load_outputs/archive_uuid

steps:
  stage_data:
    run: ./subworkflows/extract/stage_data_workflow.cwl
    in:
      bioclient_config: bioclient_config
      readgroup_fastq_uuid_list: readgroup_fastq_uuid_list
      readgroup_bam_uuid_list: readgroup_bam_uuid_list
      sample_tarball_uuid_list: sample_tarball_uuid_list
      ribosome_intervals_uuid: ribosome_intervals_uuid
      ref_flat_uuid: ref_flat_uuid
      star_index_archive_uuid: star_index_archive_uuid
      gene_info_uuid: gene_info_uuid
    out: [ ribosome_intervals, ref_flat, star_genome_dir,
           readgroup_fastq_file_list, readgroup_bam_file_list, gene_info ]

  run_rnaseq_workflow:
    run: ./subworkflows/gdc_rnaseq_main_workflow.cwl
    in:
      readgroup_bam_file_list: stage_data/readgroup_bam_file_list
      readgroup_fastq_file_list: stage_data/readgroup_fastq_file_list
      star_genome_dir: stage_data/star_genome_dir
      ref_flat: stage_data/ref_flat
      ribosome_intervals: stage_data/ribosome_intervals
      job_uuid: job_uuid
      gencode_version: gencode_version
      gene_info: stage_data/gene_info
      picard_java_mem: picard_java_mem
      threads: threads
    out: [ out_metrics_db, out_gene_counts_file, out_junctions_file,
           out_transcriptome_bam_file, out_chimeric_bam_file, out_chimeric_tsv_file,
           out_genome_bam, out_archive_file ]

  load_outputs:
    run: ./subworkflows/load/load_outputs_workflow.cwl
    in:
      metrics_db: run_rnaseq_workflow/out_metrics_db
      gene_counts: run_rnaseq_workflow/out_gene_counts_file
      junctions: run_rnaseq_workflow/out_junctions_file
      transcriptome_bam: run_rnaseq_workflow/out_transcriptome_bam_file
      chimeric_bam: run_rnaseq_workflow/out_chimeric_bam_file
      chimeric_tsv: run_rnaseq_workflow/out_chimeric_tsv_file
      genome_bam: run_rnaseq_workflow/out_genome_bam
      archive_file: run_rnaseq_workflow/out_archive_file
      job_uuid: job_uuid
      bioclient_config: bioclient_config
      upload_bucket: upload_bucket
    out: [ metrics_db_uuid, genomic_bam_uuid, genomic_bai_uuid,
           transcriptome_bam_uuid, chimeric_bam_uuid, chimeric_bai_uuid,
           chimeric_tsv_uuid, gene_counts_uuid, junctions_tsv_uuid,
           archive_uuid ]
