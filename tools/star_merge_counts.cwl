cwlVersion: v1.0
class: CommandLineTool
id: star_merge_counts
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/gdc-rnaseq-tool:1.0.0
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

baseCommand: [merge_star_gene_counts]
