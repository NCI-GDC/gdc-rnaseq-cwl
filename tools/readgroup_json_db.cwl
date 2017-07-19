#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: json_path
    type: File
    format: "edam:format_3464"
    inputBinding:
      prefix: --json_path

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.run_uuid +".log")

  - id: output_sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.run_uuid + ".db")         
          
baseCommand: [/usr/local/bin/readgroup_json_db]
