#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl

class: ExpressionTool

inputs:
  input:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

outputs:
  output:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

expression: |
  ${
    var output = [];
    for (var i = 0; i < inputs.input.length; i++) {
      var curr = inputs.input[i];
      output.push(curr);
    }

    return {'output': output}
  }
