#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star2
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: runMode
    type: string
    default: "genomeGenerate"
    inputBinding:
      prefix: --runMode

  - id: runThreadN
    type: int
    default: 1
    inputBinding:
      prefix: --runThreadN

  - id: genomeDir
    type: string
    inputBinding:
      prefix: --genomeDir

  - id: genomeFastaFiles
    type: File
    inputBinding:
      prefix: --genomeFastaFiles

  - id: sjdbGTFfile
    type: File
    inputBinding:
      prefix: --sjdbGTFfile

  - id: sjdbOverhang
    type: int
    default: 100
    inputBinding:
      prefix: --sjdbOverhang


outputs:
  - id: chrLength.txt
    type: File
    outputBinding:
      glob: chrLength.txt

  - id: chrNameLength.txt
    type: File
    outputBinding:
      glob: chrNameLength.txt

  - id: chrName.txt
    type: File
    outputBinding:
      glob: chrName.txt

  - id: chrStart.txt
    type: File
    outputBinding:
      glob: chrStart.txt

  - id: exonGeTrInfo.tab
    type: File
    outputBinding:
      glob: exonGeTrInfo.tab

  - id: exonInfo.tab
    type: File
    outputBinding:
      glob: exonInfo.tab

  - id: geneInfo.tab
    type: File
    outputBinding:
      glob: geneInfo.tab

  - id: Genome
    type: File
    outputBinding:
      glob: Genome

  - id: genomeParameters.txt
    type: File
    outputBinding:
      glob: genomeParameters.txt

  - id: Log.out
    type: File
    outputBinding:
      glob: Log.out

  - id: SA
    type: File
    outputBinding:
      glob: SA

  - id: SAindex
    type: File
    outputBinding:
      glob: SAindex

  - id: sjdbInfo.txt
    type: File
    outputBinding:
      glob: sjdbInfo.txt

  - id: sjdbList.fromGTF.out.tab
    type: File
    outputBinding:
      glob: sjdbList.fromGTF.out.tab

  - id: sjdbList.out.tab
    type: File
    outputBinding:
      glob: sjdbList.out.tab

  - id: transcriptInfo.tab
    type: File
    outputBinding:
      glob: transcriptInfo.tab

baseCommand: [/usr/local/bin/STAR]
