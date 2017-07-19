#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqvalidator-sqlite:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.run_uuid)_fastqvalidator_sqlite.log

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.run_uuid).db

          
baseCommand: [/usr/local/bin/fastqvalidator_sqlite]
