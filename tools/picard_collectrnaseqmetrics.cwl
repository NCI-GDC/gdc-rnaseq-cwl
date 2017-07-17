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

  - id: REF_FLAT
    type: File
    inputBinding:
      prefix: REF_FLAT=
      separate: false

  - id: RIBOSOMAL_INTERVALS
    type: ["null", File]
    inputBinding:
      prefix: RIBOSOMAL_INTERVALS=
      separate: false

  - id: STRAND_SPECIFICITY
    type: string
    default: "NONE"
    inputBinding:
      prefix: STRAND_SPECIFICITY=
      separate: false

  - id: MINIMUM_LENGTH
    type: int
    default: 500
    inputBinding:
      prefix: MINIMUM_LENGTH=
      separate: false

  - id: IGNORE_SEQUENCE
    default: ["null"]
    type:
      type: array
      items: string
      inputBinding:
        prefix: IGNORE_SEQUENCE=
        separate: false

  - id: RRNA_FRAGMENT_PERCENTAGE
    type: double
    default: 0.8
    inputBinding:
      prefix: RRNA_FRAGMENT_PERCENTAGE=
      separate: false

  - id: METRIC_ACCUMULATION_LEVEL
    type: string
    default: "ALL_READS"
    inputBinding:
      prefix: METRIC_ACCUMULATION_LEVEL=
      separate: false

  - id: ASSUME_SORTED
    type: string
    default: "true"
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false

  - id: STOP_AFTER
    type: long
    default: 0
    inputBinding:
      prefix: STOP_AFTER=
      separate: false

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: TMP_DIR=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot).metrics

  - id: CHART_OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot).pdf

arguments:
  - valueFrom: $(inputs.INPUT.nameroot).metrics
    prefix: OUTPUT=
    separate: false

  - valueFrom: $(inputs.INPUT.nameroot).pdf
    prefix: CHART_OUTPUT=
    separate: false

successCodes: [0, 1]

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectRnaSeqMetrics]
