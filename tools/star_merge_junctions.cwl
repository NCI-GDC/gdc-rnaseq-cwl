#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-rnaseq-tool:17481d6377170bd3d5aab8209cce586145465be9
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

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

baseCommand: [python3, /opt/gdc-rnaseq-tool/merge_star_junctions.py]
