#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star-metrics-sqlite
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: metric_name
    type: string
    default: "star_generate_intermediate_genome"
    inputBinding:
      prefix: --metric_name

  - id: chrlength_txt_path
    type: File
    inputBinding:
      prefix: --chrlength_txt_path

  - id: chrnamelength_txt_path
    type: File
    inputBinding:
      prefix: --chrnamelength_txt_path

  - id: chrname_txt_path
    type: File
    inputBinding:
      prefix: --chrname_txt_path

  - id: chrstart_txt_path
    type: File
    inputBinding:
      prefix: --chrstart_txt_path

  - id: genomeparameters_txt_path
    type: File
    inputBinding:
      prefix: --genomeparameters_txt_path

  - id: log_out_path
    type: File
    inputBinding:
      prefix: --log_out_path

  - id: sjdb_info_txt_path
    type: File
    inputBinding:
      prefix: --sjdb_info_txt_path

  - id: sjdblist_out_tab_path
    type: File
    inputBinding:
      prefix: --sjdblist_out_tab_path

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.uuid + "_" + metric_name + ".log")

  - id: sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.uuid + ".db")

baseCommand: [/usr/local/bin/star_metrics_sqlite]
