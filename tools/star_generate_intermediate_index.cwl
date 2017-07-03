#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star2
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.genome_chrLength_txt.basename)
        entry: $(inputs.genome_chrLength_txt)
        writable: True
      - entryname: $(inputs.genome_chrName_txt.basename)
        entry: $(inputs.genome_chrName_txt)
        writable: True
      - entryname: $(inputs.genome_chrStart_txt.basename)
        entry: $(inputs.genome_chrStart_txt)
        writable: True
      - entryname: $(inputs.genome_Genome.basename)
        entry: $(inputs.genome_Genome)
        writable: True
      - entryname: $(inputs.genome_genomeParameters_txt.basename)
        entry: $(inputs.genome_genomeParameters_txt)
        writable: True
      - entryname: $(inputs.genome_SA.basename)
        entry: $(inputs.genome_SA)
        writable: True
      - entryname: $(inputs.genome_SAindex.basename)
        entry: $(inputs.genome_SAindex)
        writable: True
      - entryname: $(inputs.genome_sjdbInfo_txt.basename)
        entry: $(inputs.genome_sjdbInfo_txt)
        writable: True
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: genomeDir
    type: string
    default: "."
    inputBinding:
      prefix: --genomeDir

  - id: genomeFastaFiles
    type: File
    inputBinding:
      prefix: --genomeFastaFiles

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

  - id: sjdbFileChrStartEnd
    type: File
    inputBinding:
      prefix: --sjdbFileChrStartEnd

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

  - id: sjdbList.out.tab
    type: File
    outputBinding:
      glob: sjdbList.out.tab

baseCommand: [/usr/local/bin/STAR]
