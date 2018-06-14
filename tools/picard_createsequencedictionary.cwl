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
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.REFERENCE))
    outdirMin: $(file_size_multiplier(inputs.REFERENCE))

class: CommandLineTool

inputs:
  - id: REFERENCE
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: REFERENCE=
      separate: false

  - id: URI
    type: ["null", string]
    inputBinding:
      prefix: URI=
      separate: false

  - id: SPECIES
    type: ["null", string]
    inputBinding:
      prefix: SPECIES=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.REFERENCE.nameroot).dict

arguments:
  - valueFrom: $(inputs.REFERENCE.nameroot)
    prefix: GENOME_ASSEMBLY=
    separate: false

  - valueFrom: $(inputs.REFERENCE.nameroot).dict
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -Xmx4G, -jar, /usr/local/bin/picard.jar, CreateSequenceDictionary]
