#!/usr/bin/env cwl-runner

class: CommandLineTool
cwlVersion: v1.0
doc: |
    Gzips a file

requirements:
  - class: DockerRequirement
    dockerPull: alpine:latest
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_file, 1.5))
    outdirMin: $(file_size_multiplier(inputs.input_file, 1.5))

inputs:
  input_file:
    type: File
    doc: file to compress
    inputBinding:
      position: 0

outputs:
  output_file:
    type: File
    doc: gzip compressed file
    streamable: true
    outputBinding:
      glob: $(inputs.input_file.basename + '.gz')

stdout: $(inputs.input_file.basename + '.gz')

baseCommand: [gzip, -c]
