cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.cwl

inputs:
  bam_pe_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.cwl#readgroup_fastq_file

  bam_se_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.cwl#readgroup_fastq_file

  bam_o1_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.cwl#readgroup_fastq_file

  bam_o2_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.cwl#readgroup_fastq_file

  pe_fastqs:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file

  se_fastqs:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file

outputs:
  pe_fastq_array:
    type: 
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: merge_pe_fastq_file_arrays/output 

  se_fastq_array:
    type: 
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: merge_se_fastq_file_arrays/output 

steps:
  merge_pe_bam_fastq_file_arrays:
    run: ../../tools/merge_fastq_records_two_dimension.cwl
    in:
      input: bam_pe_fastqs
    out: [ output ]

  merge_pe_fastq_file_arrays:
    run: ../../tools/merge_fastq_records_one_dimension.cwl
    in:
      input:
        linkMerge: merge_flattened
        source:
          - pe_fastqs
          - merge_pe_bam_fastq_file_arrays/output
        valueFrom: $(self)
    out: [ output ]

  merge_se_bam_fastq_file_arrays:
    run: ../../tools/merge_fastq_records_two_dimension.cwl
    in:
      input:
        linkMerge: merge_flattened
        source:
          - bam_se_fastqs 
          - bam_o1_fastqs 
          - bam_o2_fastqs 
        valueFrom: $(self)
    out: [ output ]

  merge_se_fastq_file_arrays:
    run: ../../tools/merge_fastq_records_one_dimension.cwl
    in:
      input:
        linkMerge: merge_flattened
        source:
          - se_fastqs 
          - merge_se_bam_fastq_file_arrays/output
        valueFrom: $(self)
    out: [ output ]
