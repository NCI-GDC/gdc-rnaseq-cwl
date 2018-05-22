#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.cwl

inputs:
  forward_fastq:
    type: File
  reverse_fastq:
    type: File?
  readgroup_json:
    type: File

outputs:
  output:
    type: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: emit_readgroup_fastq/output

steps:
  emit_json_readgroup_meta:
    run: ../../tools/emit_json_readgroup_meta.cwl
    in:
      input:
        source: readgroup_json
    out: [ output ]

  emit_readgroup_fastq:
    run: ../../tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: forward_fastq
      reverse_fastq: reverse_fastq
      readgroup_meta: emit_json_readgroup_meta/output
    out: [ output ]
