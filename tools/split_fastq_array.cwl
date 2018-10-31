#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  fastq_list:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

outputs:
  output:
    type:
      type: array
      items:
        type: array
        items: readgroup.cwl#readgroup_fastq_file

expression: |
  ${
     var pe = [];
     var se = [];
     for(var i = 0; i<inputs.fastq_list.length; i++) {
       var curr = inputs.fastq_list[i];
       if(curr.reverse_fastq !== null) {
         pe.push(curr)
       } else {
         se.push(curr)
       }
     }

     var out = [];
     if( pe.length > 0 ) {
       out.push(pe)
     }
     if( se.length > 0 ) {
       out.push(se)
     }

     return {'output': out} 
   }
