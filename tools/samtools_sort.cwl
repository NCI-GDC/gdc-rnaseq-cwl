cwlVersion: v1.0
class: CommandLineTool
id: samtools_sort
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/samtools:{{ samtools }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 2

  output_bam:
    type: string
    inputBinding:
      position: 1
      prefix: -o

  threads:
    type: int?
    inputBinding:
      position: 0
      prefix: -@

outputs:
  bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam)

baseCommand: [samtools, sort]
