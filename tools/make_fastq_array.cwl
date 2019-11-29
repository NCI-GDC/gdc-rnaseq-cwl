cwlVersion: v1.0
class: ExpressionTool
id: make_fastq_array
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: InlineJavascriptRequirement

inputs:
  pe_fastq_list:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

  se_fastq_list:
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
    var output = [] 
    if( inputs.pe_fastq_list.length > 0 ) {
      output.push(inputs.pe_fastq_list)
    }

    if( inputs.se_fastq_list.length > 0 ) {
      output.push(inputs.se_fastq_list)
    }

    return {'output': output}
  }
