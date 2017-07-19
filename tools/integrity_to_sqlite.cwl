#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/integrity_to_sqlite:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input_state
    type: string
    inputBinding:
      prefix: "--input_state"

  - id: ls_l_path
    type: File
    inputBinding:
      prefix: "--ls_l_path"

  - id: md5sum_path
    type: File
    inputBinding:
      prefix: "--md5sum_path"

  - id: sha256sum_path
    type: File
    inputBinding:
      prefix: "--sha256sum_path"

  - id: run_uuid
    type: string
    inputBinding:
      prefix: "--run_uuid"

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.run_uuid + ".log")

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.run_uuid + ".db")

baseCommand: [/usr/local/bin/integrity_to_sqlite]
