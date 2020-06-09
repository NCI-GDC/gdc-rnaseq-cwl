cwlVersion: v1.0
class: ExpressionTool
id: split_fastq_array
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: InlineJavascriptRequirement

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
