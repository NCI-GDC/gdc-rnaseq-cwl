cwlVersion: v1.0
class: CommandLineTool
id: picard_createsequencedictionary
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/picard:2.26.10
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.REFERENCE))
    outdirMin: $(file_size_multiplier(inputs.REFERENCE))

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
