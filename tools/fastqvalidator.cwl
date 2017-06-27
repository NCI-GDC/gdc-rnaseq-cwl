#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqvalidator
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: file
    type: File
    inputBinding:
      prefix: --file

  - id: minReadLen
    type: int
    default: 10
    inputBinding:
      prefix: --minReadLen

  - id: maxErrors
    type: long
    default: -1
    inputBinding:
      prefix: --maxErrors

  - id: printableErrors
    type: long
    default: 2147483647
    inputBinding:
      prefix: --printableErrors

  - id: ignoreErrors
    type: boolean
    default: false
    inputBinding:
      prefix: --ignoreErrors

  - id: baseComposition
    type: boolean
    default: true
    inputBinding:
      prefix: --baseComposition

  - id: avgQual
    type: boolean
    default: true
    inputBinding:
      prefix: --avgQual

  - id: disableSeqIDCheck
    type: boolean
    default: false
    inputBinding:
      prefix: --disableSeqIDCheck

  - id: noeof
    type: boolean
    default: false
    inputBinding:
      prefix: --noeof

  - id: interleaved
    type: boolean
    default: false
    inputBinding:
      prefix: --interleaved

  - id: params
    type: boolean
    default: false
    inputBinding:
      prefix: --params

  - id: quiet
    type: boolean
    default: false
    inputBinding:
      prefix: --quiet

  - id: auto
    type: boolean
    default: true
    inputBinding:
      prefix: --auto

  - id: baseSpace
    type: boolean
    default: false
    inputBinding:
      prefix: --baseSpace

  - id: colorSpace
    type: boolean
    default: false
    inputBinding:
      prefix: --colorSpace
      
outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.file.nameroot).fqv

stdout: $(inputs.file.nameroot).fqv
          
baseCommand: [/usr/local/bin/fastQValidator]
