#!/usr/bin/env cwl-runner

cwlVersion: v1.0

doc: Untar archived directory 

requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1024

class: CommandLineTool

inputs:
  input_tar:
    type: File
    doc: The tarfile to process
    inputBinding:
      position: 0
      prefix: -f

outputs:
  out_directory:
    type: Directory
    outputBinding:
      glob: |
        ${
           var idx = inputs.input_tar.basename.lastIndexOf('.tar.gz')
           if(idx == -1) {
             throw("Unexpected name extension! Must be .tar.gz")
           }
           return inputs.input_tar.basename.slice(0, idx)
         } 

baseCommand: [/bin/tar, -xz]
