#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7 
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam)
      - $(inputs.bam_index)

class: CommandLineTool

inputs:
  bam:
    type: File
    inputBinding:
      position: 0
      valueFrom: $(self.basename)

  bam_index:
    type: File

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot + ".idxstat")

stdout: $(inputs.bam.nameroot + ".idxstat")

baseCommand: [samtools, idxstats]
