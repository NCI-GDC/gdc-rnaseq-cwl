cwlVersion: v1.0
class: CommandLineTool
id: samtools_merge
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input_bam))
    outdirMin: $(sum_file_array_size(inputs.input_bam))

inputs:
  input_bam:
    type: File[]
    inputBinding:
      position: 2
    secondaryFiles:
      - ".bai"

  output_bam:
    type: string
    inputBinding:
      position: 1

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

baseCommand: [samtools, merge, -c]
