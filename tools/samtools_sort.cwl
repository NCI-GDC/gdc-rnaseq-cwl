#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 

class: CommandLineTool

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
