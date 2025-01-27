cwlVersion: v1.0
class: CommandLineTool
id: star_generate_genome
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/star2:{{ star2 }}
  - class: InlineJavascriptRequirement

inputs:
  runMode:
    type: string
    default: "genomeGenerate"
    inputBinding:
      prefix: --runMode

  runThreadN:
    type: int
    default: 1
    inputBinding:
      prefix: --runThreadN

  genomeDir:
    type: string
    inputBinding:
      prefix: --genomeDir

  genomeFastaFiles:
    type: File
    inputBinding:
      prefix: --genomeFastaFiles

  sjdbGTFfile:
    type: File
    inputBinding:
      prefix: --sjdbGTFfile

  sjdbOverhang:
    type: int
    default: 100
    inputBinding:
      prefix: --sjdbOverhang

outputs:
  - id: chrLength_txt
    type: File
    outputBinding:
      glob: chrLength.txt

  - id: chrNameLength_txt
    type: File
    outputBinding:
      glob: chrNameLength.txt

  - id: chrName_txt
    type: File
    outputBinding:
      glob: chrName.txt

  - id: chrStart_txt
    type: File
    outputBinding:
      glob: chrStart.txt

  - id: exonGeTrInfo_tab
    type: File
    outputBinding:
      glob: exonGeTrInfo.tab

  - id: exonInfo_tab
    type: File
    outputBinding:
      glob: exonInfo.tab

  - id: geneInfo_tab
    type: File
    outputBinding:
      glob: geneInfo.tab

  - id: Genome
    type: File
    outputBinding:
      glob: Genome

  - id: genomeParameters_txt
    type: File
    outputBinding:
      glob: genomeParameters.txt

  - id: Log_out
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

  - id: sjdbInfo_txt
    type: File
    outputBinding:
      glob: sjdbInfo.txt

  - id: sjdbList_fromGTF_out_tab
    type: File
    outputBinding:
      glob: sjdbList.fromGTF.out.tab

  - id: sjdbList_out_tab
    type: File
    outputBinding:
      glob: sjdbList.out.tab

  - id: transcriptInfo_tab
    type: File
    outputBinding:
      glob: transcriptInfo.tab

baseCommand: [STAR]
