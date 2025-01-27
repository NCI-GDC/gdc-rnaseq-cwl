cwlVersion: v1.0
class: CommandLineTool
id: picard_bedtointervallist
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/picard:{{ picard }}
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4000
    tmpdirMin: $(sum_file_array_size([inputs.INPUT, inputs.SEQUENCE_DICTIONARY])
    outdirMin: $(sum_file_array_size([inputs.INPUT, inputs.SEQUENCE_DICTIONARY])

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
