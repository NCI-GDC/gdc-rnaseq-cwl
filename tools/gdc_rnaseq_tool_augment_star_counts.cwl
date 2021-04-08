cwlVersion: v1.0
class: CommandLineTool
id: augment_star_counts
requirements:
  - class: DockerRequirement
    dockerPull:  quay.io/ncigdc/gdc-rnaseq-tool:1.0.0-49.1813f60
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: ${
      if (inputs.gene_info){
        return sum_file_array_size([inputs.counts, inputs.gene_info])
      } else {
        return sum_file_array_size([inputs.counts])
      }}
    outdirMin: ${
      if (inputs.gene_info){
        return sum_file_array_size([inputs.counts, inputs.gene_info])
      } else {
        return sum_file_array_size([inputs.counts])
      }}

inputs:
  counts:
    type: File
    inputBinding:
      prefix: --input
  gene_info:
    type: File
    inputBinding:
      prefix: --gene-info
  gencode_version:
    type: int
    inputBinding:
      prefix: --gencode-version
  output:
    type: string
    inputBinding:
      prefix: --output

outputs:
  output: 
    type: File
    outputBinding:
      glob: $(inputs.output)

baseCommand: [ augment_star_counts ]
