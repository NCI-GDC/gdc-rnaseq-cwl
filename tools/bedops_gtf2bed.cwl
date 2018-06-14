#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bedops:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2306"

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot).bed

stdin: $(inputs.INPUT.path)

stdout: $(inputs.INPUT.nameroot).bed

baseCommand: [/usr/local/bin/gtf2bed]
