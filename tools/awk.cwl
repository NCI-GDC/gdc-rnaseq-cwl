cwlVersion: v1.0
class: CommandLineTool
id: awk
requirements:
  - class: DockerRequirement
    dockerPull: fedora:26
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 16
    coresMax: 16
    ramMin: 9250000
    ramMax: 9250000
    tmpdirMin: $(parseInt(inputs.INPUT.size / 1024 / 1024))
    tmpdirMax: $(parseInt(inputs.INPUT.size / 1024 / 1024 * 2))
    outdirMin: $(parseInt(inputs.INPUT.size / 1024 / 1024))
    outdirMax: $(parseInt(inputs.INPUT.size / 1024 / 1024 * 2))

inputs:
  - id: INPUT
    type: File
    inputBinding:
      position: 1

  - id: EXPRESSION
    type: string
    inputBinding:
      position: 0

  - id: OUTFILE
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTFILE)

stdout: $(inputs.OUTFILE)
      
baseCommand: [awk]
