#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  bam: 
    type: File

  readgroup_meta_list:
    type: 
      type: array
      items: readgroup.cwl#readgroup_meta

outputs:
  output:
    type: readgroup.cwl#readgroup_bam_file

expression: |
  ${
    var output = { "bam": inputs.bam,
                   "readgroup_meta_list": inputs.readgroup_meta_list
                   };
    return {'output': output}
  }
