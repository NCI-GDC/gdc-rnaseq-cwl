#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: gdc_token
    type: File
  - id: input_bam_gdc_id
    type: string
  - id: known_snp_gdc_id
    type: string
  - id: known_snp_index_gdc_id
    type: string
  - id: reference_dict_gdc_id
    type: string
  - id: reference_fa_gdc_id
    type: string
  - id: ref_flat_gdc_id
    type: string
  - id: ribosomal_intervals_gdc_id
    type: string
  - id: star_genome_chrLength_txt_gdc_id
    type: string
  - id: star_genome_chrName_txt_gdc_id
    type: string
  - id: star_genome_chrStart_txt_gdc_id
    type: string
  - id: star_genome_Genome_gdc_id
    type: string
  - id: star_genome_genomeParameters_txt_gdc_id
    type: string
  - id: star_genome_SA_gdc_id
    type: string
  - id: star_genome_SAindex_gdc_id
    type: string
  - id: star_genome_sjdbInfo_txt_gdc_id
    type: string
  - id: start_token
    type: File
  - id: run_uuid
    type: string
  - id: thread_count
    type: int

outputs:
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_input_bam
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: input_bam_gdc_id
    out:
      - id: output

  - id: extract_known_snp
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_gdc_id
    out:
      - id: output

  - id: extract_known_snp_index
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_index_gdc_id
    out:
      - id: output

  - id: extract_ref_fa
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_fa_gdc_id
    out:
      - id: output

  - id: extract_ref_dict
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_dict_gdc_id
    out:
      - id: output

  - id: extract_ref_flat
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: ref_flat_gdc_id
    out:
      - id: output

  - id: extract_ribosomal_intervals
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: ribosomal_intervals_gdc_id
    out:
      - id: output

  - id: extract_star_genome_chrLength_txt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_chrLength_txt_gdc_id
    out:
      - id: output

  - id: extract_genome_chrName_txt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_chrName_txt_gdc_id
    out:
      - id: output

  - id: extract_genome_chrStart_txt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_chrStart_txt_gdc_id
    out:
      - id: output

  - id: extract_genome_Genome
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_Genome_gdc_id
    out:
      - id: output

  - id: extract_genome_genomeParameters_txt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_genomeParameters_txt_gdc_id
    out:
      - id: output

  - id: extract_genome_SA
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_SA_gdc_id
    out:
      - id: output

  - id: extract_genome_SAindex
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_SAindex_gdc_id
    out:
      - id: output

  - id: extract_genome_sjdbInfo_txt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: star_genome_sjdbInfo_txt_gdc_id
    out:
      - id: output

  - id: root_known_snp_files
    run: ../../tools/root_vcf.cwl
    in:
      - id: vcf
        source: extract_known_snp/output
      - id: vcf_index
        source: extract_known_snp_index/output
    out:
      - id: output
 
  - id: transform
    run: transform.cwl
    in:
      - id: fasta
        source: extract_ref_fa/output
      - id: genome_chrLength_txt
        source: extract_star_genome_chrLength_txt/output
      - id: genome_chrName_txt
        source: extract_genome_chrName_txt/output
      - id: genome_chrStart_txt
        source: extract_genome_chrStart_txt/output
      - id: genome_Genome
        source: extract_genome_Genome/output
      - id: genome_genomeParameters_txt
        source: extract_genome_genomeParameters_txt/output
      - id: genome_SA
        source: extract_genome_SA/output
      - id: genome_SAindex
        source: extract_genome_SAindex/output
      - id: genome_sjdbInfo_txt
        source: extract_genome_sjdbInfo_txt/output
      - id: input_bam
        source: extract_bam/output
      - id: known_snp
        source: root_known_snp_files/output
      - id: ref_flat
        source: extract_ref_flat/output
      - id: ribosomal_intervals
        source: extract_ribosomal_intervals
      - id: run_uuid
        source: run_uuid
      - id: thread_count
        source: thread_count
    out:
      - id: picard_fixmateinformation_output
      - id: merge_all_sqlite_destination_sqlite

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: transform/merge_all_sqlite_destination_sqlite
    out:
      - id: token
