#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-rnaseq-tool:4fd9fbe2eddbd9a8dab2b1ae8992efa41d811d81
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
