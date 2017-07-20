#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement

inputs:
  - id: bam
    type: File
  - id: fasta
    type: File
  - id: known_snp
    type: File
  - id: ref_flat
    type: File
  - id: ribosomal_intervals
    type: File
  - id: input_state
    type: string
  - id: run_uuid
    type: string

outputs:
  - id: merge_fastq_metrics_destination_sqlite
    type: File
    outputSource: merge_fastq_metrics/destination_sqlite

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
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: ref_flat
        source: ref_flat
        valueFrom: $(self.basename)
      - id: ribosomal_intervals
        source: ribosomal_intervals
        valueFrom: $(self.basename)
      - id: metric_path
        source: picard_collectrnaseqmetrics/OUTPUT
      - id: input_state
        valueFrom: "pass_2"
      - id: run_uuid
        source: run_uuid
    out:
      - id: sqlite

  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl
    in:
      - id: DB_SNP
        source: known_snp
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
    out:
      - id: alignment_summary_metrics
      - id: bait_bias_detail_metrics
      - id: bait_bias_summary_metrics
      - id: base_distribution_by_cycle_metrics
      - id: gc_bias_detail_metrics
      - id: gc_bias_summary_metrics
      - id: insert_size_metrics
      - id: pre_adapter_detail_metrics
      - id: pre_adapter_summary_metrics
      - id: quality_by_cycle_metrics
      - id: quality_distribution_metrics
      - id: quality_yield_metrics

  - id: picard_collectmultiplemetrics_to_sqlite
    run: ../../tools/picard_collectmultiplemetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: run_uuid
        source: run_uuid
      - id: vcf
        source: known_snp
        valueFrom: $(self.basename)
      - id: alignment_summary_metrics
        source: picard_collectmultiplemetrics/alignment_summary_metrics
      - id: bait_bias_detail_metrics
        source: picard_collectmultiplemetrics/bait_bias_detail_metrics
      - id: bait_bias_summary_metrics
        source: picard_collectmultiplemetrics/bait_bias_summary_metrics
      - id: base_distribution_by_cycle_metrics
        source: picard_collectmultiplemetrics/base_distribution_by_cycle_metrics
      - id: gc_bias_detail_metrics
        source: picard_collectmultiplemetrics/gc_bias_detail_metrics
      - id: gc_bias_summary_metrics
        source: picard_collectmultiplemetrics/gc_bias_summary_metrics
      - id: insert_size_metrics
        source: picard_collectmultiplemetrics/insert_size_metrics
      - id: pre_adapter_detail_metrics
        source: picard_collectmultiplemetrics/pre_adapter_detail_metrics
      - id: pre_adapter_summary_metrics
        source: picard_collectmultiplemetrics/pre_adapter_summary_metrics
      - id: quality_by_cycle_metrics
        source: picard_collectmultiplemetrics/quality_by_cycle_metrics
      - id: quality_distribution_metrics
        source: picard_collectmultiplemetrics/quality_distribution_metrics
      - id: quality_yield_metrics
        source: picard_collectmultiplemetrics/quality_yield_metrics
    out:
      - id: log
      - id: sqlite

  - id: picard_collectoxogmetrics
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      - id: DB_SNP
        source: known_snp
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
    out:
      - id: OUTPUT

  - id: picard_collectoxogmetrics_to_sqlite
    run: ../../tools/picard_collectoxogmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collectoxogmetrics/OUTPUT
      - id: run_uuid
        source: run_uuid
      - id: vcf
        source: known_snp
        valueFrom: $(self.basename)
    out:
      - id: log
      - id: sqlite

  - id: samtools_flagstat
    run: ../../tools/samtools_flagstat.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_flagstat_to_sqlite
    run: ../../tools/samtools_flagstat_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_flagstat/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: sqlite

  - id: samtools_idxstats
    run: ../../tools/samtools_idxstats.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_idxstats_to_sqlite
    run: ../../tools/samtools_idxstats_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_idxstats/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: sqlite

  - id: samtools_stats
    run: ../../tools/samtools_stats.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_stats_to_sqlite
    run: ../../tools/samtools_stats_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_stats/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: sqlite

  - id: merge_fastq_metrics
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          picard_collectmultiplemetrics_to_sqlite/sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          picard_collectrnaseqmetrics_to_sqlite/sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      - id: run_uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log
