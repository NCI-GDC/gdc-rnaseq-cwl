cwlVersion: v1.0
class: CommandLineTool
id: grep
requirements:
  - class: DockerRequirement
    dockerPull: fedora:{{ fedora }}

inputs:
  - id: INPUT
    type: File
    inputBinding:
      position: 1

  - id: PATTERN
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
      
baseCommand: [grep]
