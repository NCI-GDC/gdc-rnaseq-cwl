cwlVersion: v1.0
class: CommandLineTool
id: samtools_sam2bam
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/samtools:{{ samtools }}
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_sam, 1.5))
    outdirMin: $(file_size_multiplier(inputs.input_sam, 1.5))

inputs:
  input_sam:
    type: File
    inputBinding:
      position: 2 

  output_filename:
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
      glob: $(inputs.output_filename)

baseCommand: [samtools, view, -b]
