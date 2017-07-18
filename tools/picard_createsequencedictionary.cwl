#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:latest
  - class: InlineJavascriptRequirement

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

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CreateSequenceDictionary]
