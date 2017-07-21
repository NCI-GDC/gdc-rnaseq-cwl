#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_3003"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: SEQUENCE_DICTIONARY
    type: File
    inputBinding:
      prefix: SEQUENCE_DICTIONARY=
      separate: false

  - id: OUTPUT
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: SORT
    type: string
    default: "true"
    inputBinding:
      prefix: SORT=
      separate: false

  - id: UNIQUE
    type: string
    default: "false"
    inputBinding:
      prefix: UNIQUE=
      separate: false

outputs:
  - id: OUTFILE
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)

baseCommand: [java, -jar, /usr/local/bin/picard.jar, BedToIntervalList]
