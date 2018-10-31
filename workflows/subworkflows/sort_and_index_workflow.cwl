cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  input_bam: File
  output_prefix: string
  threads: int?

outputs:
  processed_bam:
    type: File
    outputSource: indexBam/output_bam

steps:
  sortBam:
    run: ../../tools/samtools_sort.cwl
    in:
      input_bam: input_bam
      threads: threads
      output_bam:
        source: output_prefix
        valueFrom: "$(self + '.sorted.bam')"
    out: [ bam ]

  indexBam:
    run: ../../tools/samtools_index.cwl
    in:
      input_bam: sortBam/bam
      threads: threads
    out: [ output_bam ]

