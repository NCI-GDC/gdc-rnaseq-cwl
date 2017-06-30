#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star2
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: alignIntronMax
    type: int
    default: 500000
    inputBinding:
      prefix: --alignIntronMax

  - id: alignMatesGapMax
    type: int
    default: 1000000
    inputBinding:
      prefix: --alignMatesGapMax

  - id: alignSJDBoverhangMin
    type: int
    default: 1
    inputBinding:
      prefix: --alignSJDBoverhangMin

  - id: genomeDir
    type: Directory
    inputBinding:
      prefix: --genomeDir

  - id: genomeLoad
    type: string
    default: "NoSharedMemory"
    inputBinding:
      prefix: --genomeLoad

  - id: outFilterMatchNminOverLread
    type: float
    default: 0.33
    inputBinding:
      prefix: --outFilterMatchNminOverLread

  - id: outFilterMismatchNmax
    type: int
    default: 10
    inputBinding:
      prefix: --outFilterMismatchNmax

  - id: outFilterMultimapNmax
    type: int
    default: 20
    inputBinding:
      prefix: --outFilterMultimapNmax

  - id: outFilterMultimapScoreRange
    type: int
    default: 1
    inputBinding:
      prefix: --outFilterMultimapScoreRange

  - id: outFilterScoreMinOverLread
    type: float
    default: 0.33
    inputBinding:
      prefix: --outFilterScoreMinOverLread

  - id: outSAMmode
    type: string
    default: "None"
    inputBinding:
      prefix: --outSAMmode

  - id: outSAMstrandField
    type: string
    default: "intronMotif"
    inputBinding:
      prefix: --outSAMstrandField

  - id: outSAMtype
    type: string
    default: "None"
    inputBinding:
      prefix: --outSAMtype

  - id: readFilesCommand
    type: string
    default: "zcat"
    inputBinding:
      prefix: --readFilesCommand

  - id: readFilesIn
    type:
      type: array
      items: File
    inputBinding:
      prefix: --readFilesIn

  - id: runMode
    type: string
    default: "alignReads"
    inputBinding:
      prefix: --runMode

  - id: runThreadN
    type: int
    default: 1
    inputBinding:
      prefix: --runThreadN

  - id: sjdbOverhang
    type: int
    default: 100
    inputBinding:
      prefix: --sjdbOverhang

  - id: sjdbScore
    type: int
    default: 2
    inputBinding:
      prefix: --sjdbScore


outputs:
  - id: Log.final.out
    type: File
    outputBinding:
      glob: Log.final.out

  - id: Log.out
    type: File
    outputBinding:
      glob: Log.out

  - id: Log.progress.out
    type: File
    outputBinding:
      glob: Log.progress.out

  - id: SJ.out.tab
    type: File
    outputBinding:
      glob: SJ.out.tab

baseCommand: [/usr/local/bin/STAR]
