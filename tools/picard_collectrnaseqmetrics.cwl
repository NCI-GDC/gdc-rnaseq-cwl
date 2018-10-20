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
    ramMin: $(inputs.java_mem * 1000) 
    tmpdirMin: $(sum_file_array_size([inputs.INPUT, inputs.REF_FLAT]))
    outdirMin: $(sum_file_array_size([inputs.INPUT, inputs.REF_FLAT]))

class: CommandLineTool

inputs:
  java_mem:
    type: int
    default: 4

  INPUT:
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false
      position: 4
    secondaryFiles:
      - ".bai"

  REF_FLAT:
    type: File
    inputBinding:
      prefix: REF_FLAT=
      separate: false
      position: 4

  RIBOSOMAL_INTERVALS:
    type: File? 
    inputBinding:
      prefix: RIBOSOMAL_INTERVALS=
      separate: false
      position: 4

  STRAND_SPECIFICITY:
    type: string?
    default: "NONE"
    inputBinding:
      prefix: STRAND_SPECIFICITY=
      separate: false
      position: 4

  MINIMUM_LENGTH:
    type: int?
    default: 500
    inputBinding:
      prefix: MINIMUM_LENGTH=
      separate: false
      position: 4

  RRNA_FRAGMENT_PERCENTAGE:
    type: double?
    default: 0.8
    inputBinding:
      prefix: RRNA_FRAGMENT_PERCENTAGE=
      separate: false
      position: 4

  METRIC_ACCUMULATION_LEVEL:
    type:
      type: array
      items: string
      inputBinding:
        prefix: METRIC_ACCUMULATION_LEVEL=
        separate: false 
    default: ["ALL_READS"]
    inputBinding:
      position: 4

  ASSUME_SORTED:
    type: string?
    default: "true"
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false
      position: 4

  STOP_AFTER:
    type: int?
    default: 0
    inputBinding:
      prefix: STOP_AFTER=
      separate: false
      position: 4

  TMP_DIR:
    type: string?
    default: "."
    inputBinding:
      prefix: TMP_DIR=
      separate: false
      position: 4

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


baseCommand: [java]

arguments:
  - valueFrom: $("-Xmx" + inputs.java_mem.toString() + "G")
    position: 1

  - valueFrom: $('/usr/local/bin/picard.jar')
    position: 2
    prefix: -jar

  - valueFrom: $('CollectRnaSeqMetrics')
    position: 3

  - valueFrom: $(inputs.INPUT.nameroot).metrics
    prefix: OUTPUT=
    separate: false
    position: 5

  - valueFrom: $(inputs.INPUT.nameroot).pdf
    prefix: CHART_OUTPUT=
    separate: false
    position: 5
