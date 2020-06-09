cwlVersion: v1.0
class: CommandLineTool
id: cat
requirements:
  - class: DockerRequirement
    dockerPull: fedora:26

inputs:
  input1:
    type: File
    inputBinding:
      position: 1

  input2:
    type: File
    inputBinding:
      position: 2

  outfile:
    type: string

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.outfile)

stdout: $(inputs.outfile)
      
baseCommand: [cat]
