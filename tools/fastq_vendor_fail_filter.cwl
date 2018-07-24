#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-rnaseq-tool:fb44241ba7e63753e54b89e3107f2a5cec06a9a8
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 4500 
    tmpdirMin: |
      ${
         var f2 = inputs.input_r2 ? file_size_multiplier(inputs.input_r2) : 0;
         return file_size_multiplier(inputs.input_r1) + f2;
       }
    outdirMin: |
      ${
         var f2 = inputs.input_r2 ? file_size_multiplier(inputs.input_r2) : 0;
         return file_size_multiplier(inputs.input_r1) + f2;
       }

inputs:
  input_r1:
    type: File
    inputBinding:
      position: 1

  input_r2:
    type: File?
    inputBinding:
      position: 2

  output_prefix:
    type: string
    inputBinding:
      position: 0
      prefix: -o
  
outputs:
  output_r1:
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + '_R1.fq.gz')

  output_r2:
    type: File?
    outputBinding:
      glob: $(inputs.output_prefix + '_R2.fq.gz')
 
baseCommand: [/opt/fqvendorfail/fqvendorfail]
