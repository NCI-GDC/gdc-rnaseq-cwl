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
      items:
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
      var readgroup_array = inputs.input[i];
      for (var j = 0; j < readgroup_array.length; j++) {
        var readgroup = readgroup_array[j];
        output.push(readgroup);
      }
    }

    return {'output': output}
  }
