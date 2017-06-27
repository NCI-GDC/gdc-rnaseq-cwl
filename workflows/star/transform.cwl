#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: input_bam
    type: File
  - id: run_uuid
    type: string
  - id: thread_count
    type: int

requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

outputs:
  []

steps:
  - id: picard_validatesamfile_original
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: input_bam
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  # need eof and dup QNAME detection
  - id: picard_validatesamfile_original_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "original"
      - id: metric_path
        source: picard_validatesamfile_original/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: sqlite

  - id: biobambam_bamtofastq
    run: ../../tools/biobambam2_bamtofastq.cwl
    in:
      - id: filename
        source: input_bam
    out:
      - id: output_fastq1
      - id: output_fastq2
      - id: output_fastq_o1
      - id: output_fastq_o2
      - id: output_fastq_s

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: input_bam
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: readgroup_json_db
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      - id: json_path
        source: bam_readgroup_to_json/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: log
      - id: output_sqlite

  - id: fastqc1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq1
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq2
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_s
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o1
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o2
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_s
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
      - id: uuid
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
      - id: uuid
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
      - id: uuid
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
      - id: uuid
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
      - id: uuid
        source: run_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: merge_fastqc_db1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db1/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db2/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_s_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_s/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o1/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o2/OUTPUT
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: fastqvalidator1
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: biobambam_bamtofastq/output_fastq1
    out:
      - id: OUTPUT

  - id: fastqvalidator2
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: biobambam_bamtofastq/output_fastq2
    out:
      - id: OUTPUT

  - id: fastqvalidator_s
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: biobambam_bamtofastq/output_fastq_o1
    out:
      - id: OUTPUT

  - id: fastqvalidator_o1
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: biobambam_bamtofastq/output_fastq_o2
    out:
      - id: OUTPUT

  - id: fastqvalidator_o2
    run: ../../tools/fastqvalidator.cwl
    scatter: file
    in:
      - id: file
        source: biobambam_bamtofastq/output_fastq_s
    out:
      - id: OUTPUT

