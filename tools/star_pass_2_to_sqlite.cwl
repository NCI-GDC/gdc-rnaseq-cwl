#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star-metrics-sqlite:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: metric_name
    type: string
    default: "star_second_pass"
    inputBinding:
      prefix: --metric_name

  - id: log_final_out_path
    type: File
    inputBinding:
      prefix: --log_final_out_path

  - id: log_out_path
    type: File
    inputBinding:
      prefix: --log_out_path

  - id: sj_out_tab_path
    type: File
    inputBinding:
      prefix: --sj_out_tab_path

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.run_uuid + "_" + inputs.metric_name + ".log")

  - id: sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.run_uuid + ".db")

baseCommand: [/usr/local/bin/star_metrics_sqlite]
