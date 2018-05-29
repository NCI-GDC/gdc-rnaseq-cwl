#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  bam:
    type: File
    inputBinding:
      position: 1

  threads:
    type: int?
    inputBinding:
      prefix: -@
      position: 0

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot + ".flagstat")

stdout: $(inputs.bam.nameroot + ".flagstat")

baseCommand: [samtools, flagstat]
