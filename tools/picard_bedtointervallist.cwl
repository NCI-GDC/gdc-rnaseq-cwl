#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:b4d47c60366e12f8cc3ffb264e510c1165801eae1d6329d94ef9e6c30e972991
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4000
    tmpdirMin: $(sum_file_array_size([inputs.INPUT, inputs.SEQUENCE_DICTIONARY])
    outdirMin: $(sum_file_array_size([inputs.INPUT, inputs.SEQUENCE_DICTIONARY])

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

baseCommand: [java, -Xmx4G, -jar, /usr/local/bin/picard.jar, BedToIntervalList]
