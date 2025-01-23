cwlVersion: v1.0
class: CommandLineTool
id: samtools_sort
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_bam, 1.8))
    outdirMin: $(file_size_multiplier(inputs.input_bam, 1.8))

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
