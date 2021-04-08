cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_stage_data_wf
requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl

inputs:
  bioclient_config: File
  readgroup_fastq_uuid_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_uuid
  readgroup_bam_uuid_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_bam_uuid
  sample_tarball_uuid_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#sample_tarball_uuid
  ribosome_intervals_uuid: string
  ref_flat_uuid: string
  star_index_archive_uuid: string
  gene_info_uuid: string

outputs:
  ribosome_intervals:
    type: File
    outputSource: extract_ribosome/output

  ref_flat: 
    type: File
    outputSource: extract_ref_flat/output

  star_genome_dir: 
    type: Directory 
    outputSource: untar_star_index/out_directory

  readgroup_fastq_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: 
      - extract_fastqs/output
      - condition_tarball_output/output
    linkMerge: merge_flattened

  readgroup_bam_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_bam_file
    outputSource: extract_bams/output
  
  gene_info:
    type: File?
    outputSource: extract_gene_info/output 

steps:
  extract_ribosome:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle: ribosome_intervals_uuid
    out: [ output ]

  extract_ref_flat:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle: ref_flat_uuid
    out: [ output ]

  extract_fastqs:
    run: ./extract_readgroup_fastq_workflow.cwl
    scatter: readgroup_fastq_uuid
    in:
      readgroup_fastq_uuid: readgroup_fastq_uuid_list
      bioclient_config: bioclient_config
    out: [ output ] 

  extract_bams:
    run: ./extract_readgroup_bam_workflow.cwl
    scatter: readgroup_bam_uuid
    in:
      readgroup_bam_uuid: readgroup_bam_uuid_list
      bioclient_config: bioclient_config
    out: [ output ]

  extract_tarballs:
    run: ./extract_readgroup_tarball_workflow.cwl
    scatter: sample_tarball_uuid
    in:
      sample_tarball_uuid: sample_tarball_uuid_list
      bioclient_config: bioclient_config
    out: [ output ]

  condition_tarball_output:
    run: ../../../tools/merge_fastq_records_two_dimension.cwl
    in:
      input: extract_tarballs/output
    out: [ output ]

  extract_star_index:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle: star_index_archive_uuid
    out: [ output ]

  untar_star_index:
    run: ../../../tools/untar_archive.cwl
    in:
      input_tar: extract_star_index/output
    out: [ out_directory ]
  
  extract_gene_info:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle: gene_info_uuid
    out: [ output ]
