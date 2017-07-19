#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement

inputs:
  - id: bam
    type: File
  - id: ref_flat
    type: File
  - id: ribosomal_intervals
    type: File
  - id: run_uuid
    type: string

outputs:
  - id: picard_collectrnaseqmetrics_to_sqlite_sqlite
    type: File
    outputSource: picard_collectrnaseqmetrics_to_sqlite/sqlite
  # - id: merge_fastq_metrics_destination_sqlite
  #   type: File
  #   outputSource: merge_fastq_metrics/destination_sqlite

steps:
  - id: picard_collectrnaseqmetrics
    run: ../../tools/picard_collectrnaseqmetrics.cwl
    in:
      - id: INPUT
        source: bam
      - id: REF_FLAT
        source: ref_flat
      - id: RIBOSOMAL_INTERVALS
        source: ribosomal_intervals
    out:
      - id: OUTPUT

  - id: picard_collectrnaseqmetrics_to_sqlite
    run: ../../tools/picard_collectrnaseqmetrics_to_sqlite.cwl
    in:
      - id: INPUT
        source: picard_collectrnaseqmetrics/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: sqlite

  # - id: merge_fastq_metrics
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: [
  #         picard_collectrnaseqmetrics_to_sqlite/sqlite,
  #       ]
  #     - id: uuid
  #       source: run_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log
