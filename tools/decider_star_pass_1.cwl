#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: fastq1_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: fastq2_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

outputs:
  - id: output_fastq_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

expression: |
   ${
      if (inputs.fastq1_paths.length != inputs.fastq2_paths.length) {
       return null;
      }
      
      var fastq_array = [];
      for (var i = 0; i < inputs.fastq1_paths.length; i++) {
        fastq_array.push(inputs.fastq1_paths[i]);
        fastq_array.push(inputs.fastq2_paths[i]);
      }

      return {'output_fastq_paths': fastq_array}
    }
