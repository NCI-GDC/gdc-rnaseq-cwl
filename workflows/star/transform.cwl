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
  []
  # - id: merge_all_sqlite_destination_sqlite
  #   type: File
  #   outputSource: merge_all_sqlite/destination_sqlite

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

  # - id: fastq_metrics
  #   run: fastq_metrics.cwl
  #   in:
  #     - id: fastq1
  #       source: biobambam_bamtofastq/output_fastq1
  #     - id: fastq2
  #       source: biobambam_bamtofastq/output_fastq2
  #     - id: fastq_o1
  #       source: biobambam_bamtofastq/output_fastq_o1
  #     - id: fastq_o2
  #       source: biobambam_bamtofastq/output_fastq_o2
  #     - id: fastq_s
  #       source: biobambam_bamtofastq/output_fastq_s
  #     - id: run_uuid
  #       source: run_uuid
  #     - id: thread_count
  #       source: thread_count
  #   out:
  #     - id: merge_fastq_metrics_destination_sqlite
        
  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: input_bam
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  # - id: readgroup_json_db
  #   run: ../../tools/readgroup_json_db.cwl
  #   scatter: json_path
  #   in:
  #     - id: json_path
  #       source: bam_readgroup_to_json/OUTPUT
  #     - id: uuid
  #       source: run_uuid
  #   out:
  #     - id: log
  #     - id: output_sqlite

  # - id: merge_readgroup_json_db
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: readgroup_json_db/output_sqlite
  #     - id: uuid
  #       source: run_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log

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
      - id: Log.final.out
      - id: Log.out
      - id: Log.progress.out
      - id: SJ.out.tab

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
        source: star_pass_1/SJ.out.tab
    out:
      - id: chrLength.txt
      - id: chrNameLength.txt
      - id: chrName.txt
      - id: chrStart.txt
      - id: Genome
      - id: genomeParameters.txt
      - id: Log.out
      - id: SA
      - id: SAindex
      - id: sjdbInfo.txt
      - id: sjdbList.out.tab

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
      - id: outFileNamePrefix
        source: input_bam
        valueFrom: $(self.basename.slice(0,-4) + "_gdc_realn.")
      - id: outSAMattrRGline
        source: decider_pass_2/output_readgroup_str
      - id: readFilesIn
        source: decider_pass_2/output_fastq_paths
    out:
      - id: Log.final.out
      - id: Log.out
      - id: Log.progress.out
      - id: output_bam
      - id: SJ.out.tab


  # - id: merge_all_sqlite
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: [
  #         picard_validatesamfile_original_to_sqlite/sqlite,
  #         merge_readgroup_json_db/destination_sqlite,
  #         fastq_metrics/merge_fastq_metrics_destination_sqlite
  #       ]
  #     - id: uuid
  #       source: run_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log
