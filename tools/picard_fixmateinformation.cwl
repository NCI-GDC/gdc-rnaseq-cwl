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
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: SORT_ORDER
    type: ["null", string]
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  - id: ASSUME_SORTED
    type: string
    default: "false"
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false

  - id: ADD_MATE_CIGAR
    type: string
    default: "true"
    inputBinding:
      prefix: ADD_MATE_CIGAR=
      separate: false

  - id: IGNORE_MISSING_MATES
    type: string
    default: "true"
    inputBinding:
      prefix: IGNORE_MISSING_MATES=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: string
    default: "STRICT"
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: CREATE_INDEX
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: REFERENCE_SEQUENCE
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.INPUT.basename)
    secondaryFiles:
      - ^.bai

arguments:
  - valueFrom: $(inputs.INPUT.basename)
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, FixMateInformation]
