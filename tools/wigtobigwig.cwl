#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/kent:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: wig
    type: File
    inputBinding:
      position: 1

  - id: size
    type: File
    inputBinding:
      position: 2

  - id: bigwig
    type: string
    inputBinding:
      position: 3

outputs:
  - id: bigwigfile
    type: File
    outputBinding:
      glob: $(inputs.bigwig)

baseCommand: [/root/bin/x86_64/wigToBigWig]
