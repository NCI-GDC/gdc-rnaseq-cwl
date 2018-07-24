#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-rnaseq-tool:fb44241ba7e63753e54b89e3107f2a5cec06a9a8
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input))
    outdirMin: $(sum_file_array_size(inputs.input))

class: CommandLineTool

inputs:
  input: 
    type:
      type: array
      items: File 
      inputBinding:
        prefix: -i 

  outfile: 
    type: string
    inputBinding:
      prefix: -o 

outputs:
  output: 
    type: File
    outputBinding:
      glob: $(inputs.outfile)

baseCommand: [python3, /opt/gdc-rnaseq-tool/merge_star_counts.py]
