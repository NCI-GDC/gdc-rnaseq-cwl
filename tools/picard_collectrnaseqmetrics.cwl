#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard@sha256:ae136ea7771a13cae6a19e944a714ce4d0fe98cec6b62dc1d05f81c912bc0251
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4000
    tmpdirMin: $(sum_file_array_size([inputs.INPUT, inputs.REF_FLAT]))
    outdirMin: $(sum_file_array_size([inputs.INPUT, inputs.REF_FLAT]))

class: CommandLineTool

inputs:
  INPUT:
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false
    secondaryFiles:
      - ".bai"

  REF_FLAT:
    type: File
    inputBinding:
      prefix: REF_FLAT=
      separate: false

  RIBOSOMAL_INTERVALS:
    type: File? 
    inputBinding:
      prefix: RIBOSOMAL_INTERVALS=
      separate: false

  STRAND_SPECIFICITY:
    type: string?
    default: "NONE"
    inputBinding:
      prefix: STRAND_SPECIFICITY=
      separate: false

  MINIMUM_LENGTH:
    type: int?
    default: 500
    inputBinding:
      prefix: MINIMUM_LENGTH=
      separate: false

  RRNA_FRAGMENT_PERCENTAGE:
    type: double?
    default: 0.8
    inputBinding:
      prefix: RRNA_FRAGMENT_PERCENTAGE=
      separate: false

  METRIC_ACCUMULATION_LEVEL:
    type:
      type: array
      items: string
      inputBinding:
        prefix: METRIC_ACCUMULATION_LEVEL=
        separate: false 
    default: ["ALL_READS"]

  ASSUME_SORTED:
    type: string?
    default: "true"
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false

  STOP_AFTER:
    type: int?
    default: 0
    inputBinding:
      prefix: STOP_AFTER=
      separate: false

  TMP_DIR:
    type: string?
    default: "."
    inputBinding:
      prefix: TMP_DIR=
      separate: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot).metrics

  CHART_OUTPUT:
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

baseCommand: [java, -Xmx4G, -jar, /usr/local/bin/picard.jar, CollectRnaSeqMetrics]
