#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement

inputs:
  - id: fastq1
    type:
      type: array
      items: File
  - id: fastq2
    type:
      type: array
      items: File
  - id: fastq_o1
    type:
      type: array
      items: File
  - id: fastq_o2
    type:
      type: array
      items: File
  - id: fastq_s
    type:
      type: array
      items: File
  - id: run_uuid
    type: string
  - id: thread_count
    type: int

outputs:
  - id: merge_fastq_metrics_destination_sqlite
    type: File
    outputSource: merge_fastq_metrics/destination_sqlite

steps:
  - id: fastqc1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastq1
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastq2
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_s
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastq_o1
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastq_o2
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastq_s
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_db1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_s
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_s/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: merge_fastqc_db1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_s_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_s/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: fastqvalidator1
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: fastq1
    out:
      - id: OUTPUT

  - id: fastqvalidator2
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: fastq2
    out:
      - id: OUTPUT

  - id: fastqvalidator_s
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: fastq_o1
    out:
      - id: OUTPUT

  - id: fastqvalidator_o1
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: fastq_o2
    out:
      - id: OUTPUT

  - id: fastqvalidator_o2
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: fastq_s
    out:
      - id: OUTPUT

  - id: fastqvalidator_db1
    run: ../../tools/fastqvalidator_db.cwl
    scatter: metric_path
    in:
      - id: metric_path
        source: fastqvalidator1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqvalidator_db2
    run: ../../tools/fastqvalidator_db.cwl
    scatter: metric_path
    in:
      - id: metric_path
        source: fastqvalidator2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqvalidator_db_s
    run: ../../tools/fastqvalidator_db.cwl
    scatter: metric_path
    in:
      - id: metric_path
        source: fastqvalidator_s/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqvalidator_db_o1
    run: ../../tools/fastqvalidator_db.cwl
    scatter: metric_path
    in:
      - id: metric_path
        source: fastqvalidator_o1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqvalidator_db_o2
    run: ../../tools/fastqvalidator_db.cwl
    scatter: metric_path
    in:
      - id: metric_path
        source: fastqvalidator_o2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: merge_fastqvalidator_db1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqvalidator_db1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqvalidator_db2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqvalidator_db2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqvalidator_db_s_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqvalidator_db_s/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqvalidator_db_o1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqvalidator_db_o1/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqvalidator_db_o2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqvalidator_db_o2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastq_metrics
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          merge_fastqc_db1_sqlite/destination_sqlite,
          merge_fastqc_db2_sqlite/destination_sqlite,
          merge_fastqc_db_s_sqlite/destination_sqlite,
          merge_fastqc_db_o1_sqlite/destination_sqlite,
          merge_fastqc_db_o2_sqlite/destination_sqlite,
          merge_fastqvalidator_db1_sqlite/destination_sqlite,
          merge_fastqvalidator_db2_sqlite/destination_sqlite,
          merge_fastqvalidator_db_s_sqlite/destination_sqlite,
          merge_fastqvalidator_db_o1_sqlite/destination_sqlite,
          merge_fastqvalidator_db_o2_sqlite/destination_sqlite
        ]
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log
