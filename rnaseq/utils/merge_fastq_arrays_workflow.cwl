cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_merge_fastq_arrays_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl

inputs:
  bam_pe_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../../tools/readgroup.cwl#readgroup_fastq_file

  bam_se_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../../tools/readgroup.cwl#readgroup_fastq_file

  bam_o1_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../../tools/readgroup.cwl#readgroup_fastq_file

  bam_o2_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../../tools/readgroup.cwl#readgroup_fastq_file

  fastqs:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file

outputs:
  fastq_array:
    type: 
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: merge_one_dim/output 

steps:
  merge_two_dim:
    run: ../../../tools/merge_fastq_records_two_dimension.cwl
    in:
      input:
        linkMerge: merge_flattened
        source:
          - bam_pe_fastqs
          - bam_se_fastqs 
          - bam_o1_fastqs 
          - bam_o2_fastqs 
        valueFrom: $(self)
    out: [ output ]

  merge_one_dim:
    run: ../../../tools/merge_fastq_records_one_dimension.cwl
    in:
      input:
        linkMerge: merge_flattened
        source:
          - merge_two_dim/output 
          - fastqs 
        valueFrom: $(self)
    out: [ output ]
