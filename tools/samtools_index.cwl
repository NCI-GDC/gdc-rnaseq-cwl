cwlVersion: v1.0
class: CommandLineTool
id: samtools_index
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_bam)
        writable: false
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_bam))
    outdirMin: $(file_size_multiplier(inputs.input_bam))

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

  threads:
    type: int?
    inputBinding:
      position: 0
      prefix: -@

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename)
    secondaryFiles:
      - ".bai"

baseCommand: [samtools, index, -b]
