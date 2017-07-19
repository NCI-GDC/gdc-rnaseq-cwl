#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    inputBinding:
      prefix: --INPUT

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid
outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.uuid + ".log")

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".db")

          
baseCommand: [/usr/local/bin/fastqc_db]
