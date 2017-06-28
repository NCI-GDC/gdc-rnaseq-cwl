#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqvalidator-sqlite
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

  - id: uuid
    type: string
    inputBinding:
      prefix: --uuid

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.uuid)_fastqvalidator_sqlite.log

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.uuid).db

          
baseCommand: [/usr/local/bin/fastqvalidator_sqlite]
