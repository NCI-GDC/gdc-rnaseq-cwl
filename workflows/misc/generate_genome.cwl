#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: gtf
    type: File
  - id: fasta
    type: File
  - id: run_uuid
    type: string
  - id: thread_count
    type: int

requirements:
  - class: StepInputExpressionRequirement

outputs:
  - id: star_chrLength_txt
    type: File
    outputSource: star_generate_genome_indices/chrLength_txt
  - id: star_chrNameLength_txt
    type: File
    outputSource: star_generate_genome_indices/chrNameLength_txt
  - id: star_chrName_txt
    type: File
    outputSource: star_generate_genome_indices/chrName_txt
  - id: star_chrStart_txt
    type: File
    outputSource: star_generate_genome_indices/chrStart_txt
  - id: star_exonGeTrInfo_tab
    type: File
    outputSource: star_generate_genome_indices/exonGeTrInfo_tab
  - id: star_exonInfo_tab
    type: File
    outputSource: star_generate_genome_indices/exonInfo_tab
  - id: star_geneInfo_tab
    type: File
    outputSource: star_generate_genome_indices/geneInfo_tab
  - id: star_Genome
    type: File
    outputSource: star_generate_genome_indices/Genome
  - id: star_genomeParameters_txt
    type: File
    outputSource: star_generate_genome_indices/genomeParameters_txt
  - id: star_Log_out
    type: File
    outputSource: star_generate_genome_indices/Log_out
  - id: star_SA
    type: File
    outputSource: star_generate_genome_indices/SA
  - id: star_SAindex
    type: File
    outputSource: star_generate_genome_indices/SAindex
  - id: star_sjdbInfo_txt
    type: File
    outputSource: star_generate_genome_indices/sjdbInfo_txt
  - id: star_sjdbList_fromGTF_out_tab
    type: File
    outputSource: star_generate_genome_indices/sjdbList_fromGTF_out_tab
  - id: star_sjdbList_out_tab
    type: File
    outputSource: star_generate_genome_indices/sjdbList_out_tab
  - id: star_transcriptInfo_tab
    type: File
    outputSource: star_generate_genome_indices/transcriptInfo_tab

steps:
  - id: star_generate_genome_indices
    run: ../../tools/star_generate_genome.cwl
    in:
      - id: runThreadN
        source: thread_count
      - id: genomeFastaFiles
        source: fasta
      - id: sjdbGTFfile
        source: gtf
    out:
      - id: chrLength_txt
      - id: chrNameLength_txt
      - id: chrName_txt
      - id: chrStart_txt
      - id: exonGeTrInfo_tab
      - id: exonInfo_tabw
      - id: geneInfo_tab
      - id: Genome
      - id: genomeParameters_txt
      - id: Log_out
      - id: SA
      - id: SAindex
      - id: sjdbInfo_txt
      - id: sjdbList_fromGTF_out_tab
      - id: sjdbList_out_tab
      - id: transcriptInfo_tab
