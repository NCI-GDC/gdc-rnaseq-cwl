#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_db)
        writable: true
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-qcmetrics-tool:b06eec26aa9f9763c1a25bf2e5e15193e27973ba
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
