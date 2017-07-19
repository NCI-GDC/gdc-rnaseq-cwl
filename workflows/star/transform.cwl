#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: fasta
    type: File
  - id: genome_chrLength_txt
    type: File
  - id: genome_chrName_txt
    type: File
  - id: genome_chrStart_txt
    type: File
  - id: genome_Genome
    type: File
  - id: genome_genomeParameters_txt
    type: File
  - id: genome_SA
    type: File
  - id: genome_SAindex
    type: File
  - id: genome_sjdbInfo_txt
    type: File
  - id: input_bam
    type: File
  - id: known_snp
    type: File
  - id: ref_flat
    type: File
  - id: ribosomal_intervals
    type: File
  - id: run_uuid
    type: string
  - id: thread_count
    type: int

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

outputs:
  - id: star_pass_2_output_bam
    type: File
    outputSource: star_pass_2/output_bam
  - id: merge_all_sqlite_destination_sqlite
    type: File
    outputSource: merge_all_sqlite/destination_sqlite

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

  - id: fastq_metrics
    run: fastq_metrics.cwl
    in:
      - id: fastq1
        source: biobambam_bamtofastq/output_fastq1
      - id: fastq2
        source: biobambam_bamtofastq/output_fastq2
      - id: fastq_o1
        source: biobambam_bamtofastq/output_fastq_o1
      - id: fastq_o2
        source: biobambam_bamtofastq/output_fastq_o2
      - id: fastq_s
        source: biobambam_bamtofastq/output_fastq_s
      - id: run_uuid
        source: run_uuid
      - id: thread_count
        source: thread_count
    out:
      - id: merge_fastq_metrics_destination_sqlite
        
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

  - id: merge_readgroup_json_db
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: readgroup_json_db/output_sqlite
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: decider_pass_1
    run: ../../tools/decider_star_pass_1.cwl
    in:
      - id: fastq1_paths
        source: biobambam_bamtofastq/output_fastq1
      - id: fastq2_paths
        source: biobambam_bamtofastq/output_fastq2
    out:
      - id: output_fastq_paths

  - id: star_pass_1
    run: ../../tools/star_pass_1.cwl
    in:
      - id: readFilesIn
        source: decider_pass_1/output_fastq_paths
      - id: genome_chrLength_txt
        source: genome_chrLength_txt
      - id: genome_chrName_txt
        source: genome_chrName_txt
      - id: genome_chrStart_txt
        source: genome_chrStart_txt
      - id: genome_Genome
        source: genome_Genome
      - id: genome_genomeParameters_txt
        source: genome_genomeParameters_txt
      - id: genome_SA
        source: genome_SA
      - id: genome_SAindex
        source: genome_SAindex
      - id: genome_sjdbInfo_txt
        source: genome_sjdbInfo_txt
    out:
      - id: Log_final_out
      - id: Log_out
      - id: Log_progress_out
      - id: SJ_out_tab

  - id: star_pass_1_to_sqlite
    run: ../../tools/star_pass_1_to_sqlite.cwl
    in:
      - id: log_final_out_path
        source: star_pass_1/Log_final_out
      - id: log_out_path
        source: star_pass_1/Log_out
      - id: sj_out_tab_path
        source: star_pass_1/SJ_out_tab
      - id: run_uuid
        source: run_uuid
    out:
      - id: log
      - id: sqlite

  - id: star_generate_intermediate_index
    run: ../../tools/star_generate_intermediate_index.cwl
    in:
      - id: genomeFastaFiles
        source: fasta
      - id: genome_chrLength_txt
        source: genome_chrLength_txt
      - id: genome_chrName_txt
        source: genome_chrName_txt
      - id: genome_chrStart_txt
        source: genome_chrStart_txt
      - id: genome_Genome
        source: genome_Genome
      - id: genome_genomeParameters_txt
        source: genome_genomeParameters_txt
      - id: genome_SA
        source: genome_SA
      - id: genome_SAindex
        source: genome_SAindex
      - id: genome_sjdbInfo_txt
        source: genome_sjdbInfo_txt
      - id: sjdbFileChrStartEnd
        source: star_pass_1/SJ_out_tab
    out:
      - id: chrLength_txt
      - id: chrNameLength_txt
      - id: chrName_txt
      - id: chrStart_txt
      - id: Genome
      - id: genomeParameters_txt
      - id: Log_out
      - id: SA
      - id: SAindex
      - id: sjdbInfo_txt
      - id: sjdbList_out_tab

  - id: star_generate_intermediate_index_to_sqlite
    run: ../../tools/star_generate_intermediate_index_to_sqlite.cwl
    in:
      - id: chrlength_txt_path
        source: star_generate_intermediate_index/chrLength_txt
      - id: chrnamelength_txt_path
        source: star_generate_intermediate_index/chrNameLength_txt
      - id: chrname_txt_path
        source: star_generate_intermediate_index/chrName_txt
      - id: chrstart_txt_path
        source: star_generate_intermediate_index/chrStart_txt
      - id: genomeparameters_txt_path
        source: star_generate_intermediate_index/genomeParameters_txt
      - id: log_out_path
        source: star_generate_intermediate_index/Log_out
      - id: sjdb_info_txt_path
        source: star_generate_intermediate_index/sjdbInfo_txt
      - id: sjdblist_out_tab_path
        source: star_generate_intermediate_index/sjdbList_out_tab
      - id: run_uuid
        source: run_uuid
    out:
      - id: log
      - id: sqlite

  - id: decider_pass_2
    run: ../../tools/decider_star_pass_2.cwl
    in:
      - id: fastq1_paths
        source: biobambam_bamtofastq/output_fastq1
      - id: fastq2_paths
        source: biobambam_bamtofastq/output_fastq2
      - id: readgroup_paths
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_fastq_paths
      - id: output_readgroup_str

  - id: star_pass_2
    run: ../../tools/star_pass_2.cwl
    in:
      - id: genome_chrLength_txt
        source: star_generate_intermediate_index/chrLength_txt
      - id: genome_chrName_txt
        source: star_generate_intermediate_index/chrName_txt
      - id: genome_chrStart_txt
        source: star_generate_intermediate_index/chrStart_txt
      - id: genome_Genome
        source: star_generate_intermediate_index/Genome
      - id: genome_genomeParameters_txt
        source: star_generate_intermediate_index/genomeParameters_txt
      - id: genome_SA
        source: star_generate_intermediate_index/SA
      - id: genome_SAindex
        source: star_generate_intermediate_index/SAindex
      - id: genome_sjdbInfo_txt
        source: star_generate_intermediate_index/sjdbInfo_txt
      - id: outFileNamePrefix
        source: input_bam
        valueFrom: $(self.basename.slice(0,-4) + "_gdc_realn.")
      - id: outSAMattrRGline
        source: decider_pass_2/output_readgroup_str
      - id: readFilesIn
        source: decider_pass_2/output_fastq_paths
    out:
      - id: Log_final_out
      - id: Log_out
      - id: Log_progress_out
      - id: output_bam
      - id: SJ_out_tab

  - id: star_pass_2_to_sqlite
    run: ../../tools/star_pass_2_to_sqlite.cwl
    in:
      - id: log_final_out_path
        source: star_pass_2/Log_final_out
      - id: log_out_path
        source: star_pass_2/Log_out
      - id: sj_out_tab_path
        source: star_pass_2/SJ_out_tab
      - id: run_uuid
        source: run_uuid
    out:
      - id: log
      - id: sqlite

  - id: picard_buildbamindex
    run: ../../tools/picard_buildbamindex.cwl
    in:
      - id: INPUT
        source: input_bam
      - id: VALIDATION_STRINGENCY
        valueFrom: "STRICT"
    out:
      - id: OUTPUT

  - id: bam_metrics
    run: bam_metrics.cwl
    in:
      - id: bam
        source: picard_buildbamindex/OUTPUT
      - id: fasta
        source: fasta
      - id: known_snp
        source: known_snp
      - id: ref_flat
        source: ref_flat
      - id: ribosomal_intervals
        source: ribosomal_intervals
      - id: input_state
        valueFrom: "pass_2"
      - id: run_uuid
        source: run_uuid
    out:
      - id: merge_fastq_metrics_destination_sqlite

  - id: picard_validatesamfile_pass_2
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: picard_buildbamindex/OUTPUT
      - id: VALIDATION_STRINGENCY
        valueFrom: "STRICT"
    out:
      - id: OUTPUT

  # need eof and dup QNAME detection
  - id: picard_validatesamfile_pass_2_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "original"
      - id: metric_path
        source: picard_validatesamfile_pass_2/OUTPUT
      - id: run_uuid
        source: run_uuid
    out:
      - id: sqlite

  - id: integrity
    run: integrity.cwl
    in:
      - id: bai
        source: picard_buildbamindex/OUTPUT
        valueFrom: $(self.secondaryFiles[0])
      - id: bam
        source: picard_buildbamindex/OUTPUT
      - id: input_state
        valueFrom: ""
      - id: run_uuid
        source: run_uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: merge_all_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          picard_validatesamfile_original_to_sqlite/sqlite,
          picard_validatesamfile_pass_2_to_sqlite/sqlite,
          merge_readgroup_json_db/destination_sqlite,
          fastq_metrics/merge_fastq_metrics_destination_sqlite,
          star_pass_1_to_sqlite/sqlite,
          star_generate_intermediate_index_to_sqlite/sqlite,
          star_pass_2_to_sqlite/sqlite,
          integrity/merge_sqlite_destination_sqlite
        ]
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log
