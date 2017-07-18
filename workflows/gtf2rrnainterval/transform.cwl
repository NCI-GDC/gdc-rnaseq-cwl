#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: gtf
    type: File
  - id: fasta
    type: File
  - id: ribo_rna_pattern
    type: string
  - id: species
    type: string
  - id: transcript_pattern
    type: string

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

outputs:
  - id: bedtointerval_output
    type: File
    outputSource: bedtointerval/OUTFILE

steps:
  - id: sequencedictionary
    run: ../../tools/picard_createsequencedictionary.cwl
    in:
      - id: REFERENCE
        source: fasta
      - id: SPECIES
        source: species
    out:
      - id: OUTPUT

  - id: gtf_header
    run: ../../tools/grep.cwl
    in:
      - id: INPUT
        source: gtf
      - id: PATTERN
        valueFrom: "#"
      - id: OUTFILE
        source: gtf
        valueFrom: $(self.basename).hdr
    out:
      - id: OUTPUT
        
  - id: gtf_rRNA
    run: ../../tools/grep.cwl
    in:
      - id: INPUT
        source: gtf
      - id: PATTERN
        source: ribo_rna_pattern
      - id: OUTFILE
        source: gtf
        valueFrom: $(self.basename).rRNA
    out:
      - id: OUTPUT

  - id: gtf_transcript
    run: ../../tools/awk.cwl
    in:
      - id: INPUT
        source: gtf_rRNA/OUTPUT
      - id: EXPRESSION
        source: transcript_pattern
      - id: OUTFILE
        source: gtf
        valueFrom: $(self.basename).rRNA.transcript
    out:
      - id: OUTPUT

  - id: combine_gtf_header_data
    run: ../../tools/cat.cwl
    in:
      - id: input1
        source: gtf_header/OUTPUT
      - id: input2
        source: gtf_transcript/OUTPUT
      - id: outfile
        source: gtf
        valueFrom: $(self.nameroot + ".rRNA.transcript" + self.nameext)
    out:
      - id: OUTPUT

  - id: gtftobed
    run: ../../tools/bedops_gtf2bed.cwl
    in:
      - id: INPUT
        source: combine_gtf_header_data/OUTPUT
    out:
      - id: OUTPUT

  - id: bedtointerval
    run: ../../tools/picard_bedtointervallist.cwl
    in:
      - id: INPUT
        source: gtftobed/OUTPUT
      - id: SEQUENCE_DICTIONARY
        source: sequencedictionary/OUTPUT
      - id: OUTPUT
        source: gtf
        valueFrom: $(self.nameroot + ".rRNA.transcript.list")
    out:
      - id: OUTFILE
