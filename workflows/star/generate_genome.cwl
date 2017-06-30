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
  - id: star_genomeDir_value
    type: string
  - id: star_runMode_value
    type: string
  - id: star_sjdbOverhang_value
    type: int
  - id: thread_count
    type: int

requirements:
  - class: StepInputExpressionRequirement

outputs:
  - id: star_chrLength.txt
    type: File
    outputSource: star_generate_genome_indices/chrLength.txt
  - id: star_chrName.txt
    type: File
    outputSource: star_generate_genome_indices/chrName.txt
  - id: star_chrStart.txt
    type: File
    outputSource: star_generate_genome_indices/chrStart.txt
  - id: star_genome
    type: File
    outputSource: star_generate_genome_indices/Genome
  - id: star_genomeParameters.txt
    type: File
    outputSource: star_generate_genome_indices/genomeParameters.txt
  - id: star_sa
    type: File
    outputSource: star_generate_genome_indices/SA
  - id: star_saindex
    type: File
    outputSource: star_generate_genome_indices/SAindex
  - id: star_sjdbInfo.txt
    type: File
    outputSource: star_generate_genome_indices/sjdbInfo.txt

steps:
  - id: star_generate_genome_indices
    run: ../../tools/star_generate_genome.cwl
    in:
      - id: runThreadN
        source: thread_count
      - id: runMode
        source: star_runMode_value
      - id: genomeDir
        source: star_genomeDir_value
      - id: genomeFastaFiles
        source: fasta
      - id: sjdbGTFfile
        source: gtf
      - id: sjdbOverhang
        source: star_sjdbOverhang_value
    out:
      - id: chrLength.txt
      - id: chrName.txt
      - id: chrStart.txt
      - id: Genome
      - id: genomeParameters.txt
      - id: SA
      - id: SAindex
      - id: sjdbInfo.txt
