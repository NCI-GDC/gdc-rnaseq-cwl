cwlVersion: v1.0
class: CommandLineTool
id: gdc_qc_tool_picard
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_db)
        writable: true
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-qcmetrics-tool:b64e0be545e2a50a1978f34aab2ca3e3698fa7fa
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input) + sum_file_array_size([inputs.input_db, inputs.bam]))
    outdirMin: $(sum_file_array_size(inputs.input) + sum_file_array_size([inputs.input_db, inputs.bam]))

inputs:
  input: 
    type:
      type: array
      items: File 
      inputBinding:
        prefix: -i 

  job_uuid: 
    type: string
    inputBinding:
      prefix: -j

  bam:
    type: File
    inputBinding:
      prefix: --derived_from_file

  input_db:
    type: File
    inputBinding:
      prefix: --output
      valueFrom: $(self.basename)

  export_format:
    type: string?
    default: "sqlite"
    inputBinding:
      prefix: --export_format

outputs:
  db: 
    type: File
    outputBinding:
      glob: $(inputs.input_db.basename)

baseCommand:
  - bio-qcmetrics-tool 
  - export 
  - picardmetrics
