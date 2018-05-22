#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_db)
        writable: true

  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

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

  input_db:
    type: File
    inputBinding:
      prefix: --output_sqlite
      valueFrom: $(self.basename)

outputs:
  db: 
    type: File
    outputBinding:
      glob: $(inputs.input_db.basename)

baseCommand:
  - /home/ubuntu/Programming/cri-bio-376-gdc/tool_dev/gdc-qc-tool/venv/bin/python
  - /home/ubuntu/Programming/cri-bio-376-gdc/tool_dev/gdc-qc-tool/quick.py 
  - fastqcmodule 
