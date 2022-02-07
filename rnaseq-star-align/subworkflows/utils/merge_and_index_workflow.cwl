cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_merge_and_index_wf

inputs:
  input_bam: File[]
  output_bam_name: string
  threads: int?

outputs:
  merged_bam:
    type: File
    outputSource: indexBam/output_bam

steps:
  mergeBam:
    run: ../../../tools/samtools_merge.cwl
    in:
      input_bam: input_bam
      threads: threads
      output_bam: output_bam_name
    out: [ bam ]

  indexBam:
    run: ../../../tools/samtools_index.cwl
    in:
      input_bam: mergeBam/bam
      threads: threads
    out: [ output_bam ]
