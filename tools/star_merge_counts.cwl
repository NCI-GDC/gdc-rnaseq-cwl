cwlVersion: v1.0
class: CommandLineTool
id: star_merge_counts
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gdc-rnaseq-tool:c52fbf53552b9faea617dca86b0ce289cc3dafc8
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input))
    outdirMin: $(sum_file_array_size(inputs.input))

inputs:
  input: 
    type:
      type: array
      items: File 
      inputBinding:
        prefix: -i 

  outfile: 
    type: string
    inputBinding:
      prefix: -o 

outputs:
  output: 
    type: File
    outputBinding:
      glob: $(inputs.outfile)

baseCommand: [gdc-rnaseq-tools, merge_star_gene_counts]
