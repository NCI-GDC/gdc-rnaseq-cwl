#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: fedora:26

class: CommandLineTool

inputs:
  - id: input1
    type: File
    inputBinding:
      position: 1

  - id: input2
    type: File
    inputBinding:
      position: 2

  - id: outfile
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.outfile)

stdout: $(inputs.outfile)
      
baseCommand: [cat]
