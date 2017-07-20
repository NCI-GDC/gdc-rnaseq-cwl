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

  - id: fastq_s_paths
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
      var fastq_array = [];

      if (inputs.fastq1_paths.length > 0 and inputs.fastq1_paths.length == inputs.fastq2_paths.length) {
        for (var i = 0; i < inputs.fastq1_paths.length; i++) {
          fastq_array.push(inputs.fastq1_paths[i]);
          fastq_array.push(inputs.fastq2_paths[i]);
        }
      }
      else {
        for (var i = 0; i < inputs.fastq_s_paths.length; i++) {
          fastq_array.push(inputs.fastq_s_paths[i]);
        }
      }


      return {'output_fastq_paths': fastq_array}
    }
