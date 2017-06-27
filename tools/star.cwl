#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star2
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: parametersFiles
    type: ["null", File]
    inputBinding:
      prefix: --parametersFiles

  - id: sysShell
    type: string
    default: "/bin/bash"
    inputBinding:
      prefix: --sysShell

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

  - id: runDirPerm
    type: string
    default: "User_RWX"
    inputBinding:
      prefix: --runDirPerm

  - id: runRNGseed
    type: int
    default: 777
      prefix: --runRNGseed

  - id: genomeDir
    type: Directory
    inputBinding:
      prefix: --genomeDir

  - id: genomeLoad
    type: string
    default: "NoSharedMemory"
    inputBinding:
      prefix: --genomeLoad

  - id: genomeFastaFiles
    type: File
    inputBinding:
      prefix: --genomeFastaFiles

  - id: genomeChrBinNbits
    type: int
    default: 18
    inputBinding:
      prefix: --genomeChrBinNbits

  - id: genomeSAindexNbases
    type: int
    default: 14
    inputBinding:
      prefix: --genomeSAindexNbases

  - id: genomeSAsparseD
    type: int
    default: 1
    inputBinding:
      prefix: --genomeSAsparseD

  - id: genomeSuffixLengthMax
    type: int
    default: -1
    inputBinding:
      prefix: --genomeSuffixLengthMax

  - id: genomeChainFiles
    type: File
    inputBinding:
      prefix: --genomeChainFiles

  - id: genomeFileSizes
    type: long
    inputBinding:
      prefix: --genomeFileSizes

  - id: readFilesIn
    type: File
    inputBinding:
      prefix: --readFilesIn


outputs:
  []

baseCommand: [/usr/local/bin/STAR]
