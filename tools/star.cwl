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
    default: 0
    inputBinding:
      prefix: --genomeFileSizes

  - id: sjdbFileChrStartEnd
    type: File
    inputBinding:
      prefix: --sjdbFileChrStartEnd

  - id: sjdbGTFfile
    type: File
    inputBinding:
      prefix: --sjdbGTFfile

  - id: sjdbGTFchrPrefix
    type: string
    inputBinding:
      prefix: --sjdbGTFchrPrefix

  - id: sjdbGTFfeatureExon
    type: string
    inputBinding:
      prefix: --sjdbGTFfeatureExon

  - id: sjdbGTFtagExonParentTranscript
    type: string
    inputBinding:
      prefix: --sjdbGTFtagExonParentTranscript

  - id: sjdbGTFtagExonParentGene
    type: string:
    inputBinding:
      prefix: --sjdbGTFtagExonParentGene

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

  - id: sjdbInsertSave
    type: string
    default: "Basic"
    inputBinding:
      prefix: --sjdbInsertSave

  - id: inputBAMfile
    type: File
    inputBinding:
      prefix: --inputBAMfile

  - id: readFilesIn
    type: File
    inputBinding:
      prefix: --readFilesIn

  - id: readFilesCommand
    type: string
    inputBinding:
      prefix: --readFilesCommand

  - id: readMapNumber
    type: int
    inputBinding:
      prefix: --readMapNumber

  - id: readMatesLengthsIn
    type: string
    default: "NotEqual"
    inputBinding:
      prefix: --readMatesLengthsIn

  - id: readNameSeparator
    type: string
    default: "/"
    inputBinding:
      prefix: --readNameSeparator

  - id: clip3pNbases
    type: int
    default: 0
    inputBinding:
      prefix: --clip3pNbases

  - id: clip5pNbases
    type: int
    default: 0
    inputBinding:
      prefix: --clip5pNbases

  - id: clip3pAdapterSeq
    type: string
    inputBinding:
      prefix: --clip3pAdapterSeq

  - id: clip3pAdapterMMp
    type: double
    default: 0.1
    inputBinding:
      prefix: --clip3pAdapterMMp

  - id: clip3pAfterAdapterNbases
    type: int
    default: 0
    inputBinding:
      prefix: --clip3pAfterAdapterNbases

  - id: limitGenomeGenerateRAM
    type: long
    default: 31000000000
    inputBinding:
      prefix: --limitGenomeGenerateRAM

  - id: limitIObufferSize
    type: long
    default: 150000000
    inputBinding:
      prefix: --limitIObufferSize

  - id: limitOutSAMoneReadBytes
    type: long
    default: 100000
    inputBinding:
      prefix: --limitOutSAMoneReadBytes

  - id: limitOutSJoneRead
    type: int
    default: 1000
    inputBinding:
      prefix: --limitOutSJoneRead

  - id: limitOutSJcollapsed
    type: long
    default: 1000000
    inputBinding:
      prefix: --limitOutSJcollapsed

  - id: limitBAMsortRAM
    type: long
    default: 0
    inputBinding:
      prefix: --limitBAMsortRAM

  - id: limitSjdbInsertNsj
    type: long
    default: 1000000
    inputBinding:
      prefix: --limitSjdbInsertNsj

  - id: outFileNamePrefix
    type: string
    default: "./"
    inputBinding:
      prefix: --outFileNamePrefix

  - id: outTmpDir
    type: Directory
    inputBinding:
      prefix: --outTmpDir

  - id: outTmpKeep
    type: string
    inputBinding:
      prefix: --outTmpKeep

  - id: outStd
    type: string
    default: "Log"
    inputBinding:
      prefix: --outStd

  - id: outReadsUnmapped
    type: string
    default: "None"
    inputBinding:
      prefix: --outReadsUnmapped

  - id: outQSconversionAdd
    type: int
    defualt: 0
    inputBinding:
      prefix: --outQSconversionAdd

  - id: outMultimapperOrder
    type: string
    default: "Old_2.4"
    inputBinding:
      prefix: --outMultimapperOrder

  - id: outSAMtype
    type: string
    default: "SAM"
    inputBinding:
      prefix: --outSAMtype

  - id: outSAMmode
    type: string
    default: "Full"
    inputBinding:
      prefix: --outSAMmode

  - id: outSAMstrandField
    type: string
    default: "None"
    inputBinding:
      prefix: --outSAMstrandField

  - id: outSAMattributes
    type: string
    default: "Standard"
    inputBinding:
      prefix: --outSAMattributes

  - id: outSAMattrIHstart
    type: int
    default: 1
    inputBinding:
      prefix: --outSAMattrIHstart

  - id: outSAMunmapped
    type: string
    default: "None"
    inputBinding:
      prefix: --outSAMunmapped

  - id: outSAMorder
    type: string
    default: "Paired"
    inputBinding:
      prefix: --outSAMorder

  - id: outSAMprimaryFlag
    type: string
    default: "OneBestScore"
    inputBinding:
      prefix: --outSAMprimaryFlag

  - id: outSAMreadID
    type: string
    default: "Standard"
    inputBinding:
      prefix: --outSAMreadID

  - id: outSAMmapqUnique
    type: int
    default: 255
    inputBinding:
      prefix: --outSAMmapqUnique

  - id: outSAMflagOR
    type: int
    default: 0
    inputBinding:
      prefix: --outSAMflagOR

  - id: outSAMflagAND
    type: int
    default: 65535
    inputBinding:
      prefix: --outSAMflagAND

  - id: outSAMattrRGline
    type: string
    inputBinding:
      prefix: --outSAMattrRGline

  - id: outSAMheaderHD
    type: string
    inputBinding:
      prefix: --outSAMheaderHD

  - id: outSAMheaderPG
    type: string
    inputBinding:
      prefix: --outSAMheaderPG

  - id: outSAMheaderCommentFile
    type: File
    inputBinding:
      prefix: --outSAMheaderCommentFile

  - id: outSAMfilter
    type: string
    default: "None"
    inputBinding:
      prefix: --outSAMfilter

  - id: outSAMmultNmax
    type: int
    default: -1
    inputBinding:
      prefix: --outSAMmultNmax

  - id: outBAMcompression
    type: int
    default: 1
    inputBinding:
      prefix: --outBAMcompression

  - id: outBAMsortingThreadN
    type: int
    default: 0
    inputBinding:
      prefix: --outBAMsortingThreadN

  - id: bamRemoveDuplicatesType
    type: string
    default: "-"
    inputBinding:
      prefix: --bamRemoveDuplicatesType

  - id: bamRemoveDuplicatesMate2basesN
    type: int
    default: 0
    inputBinding:
      prefix: --bamRemoveDuplicatesMate2basesN

  - id: outWigType
    type: string
    default: "None"
    inputBinding:
      prefix: --outWigType

  - id: outWigStrand
    type: string
    default: "Stranded"
    inputBinding:
      prefix: --outWigStrand

  - id: outWigReferencesPrefix
    type: string
    default: "-"
    inputBinding:
      prefix: --outWigReferencesPrefix

  - id: outWigNorm
    type: string
    default: "RPM"
    inputBinding:
      prefix: --outWigNorm

  - id: outFilterType
    type: string
    default: "Normal"
    inputBinding:
      prefix: --outFilterType

  - id: outFilterMultimapScoreRange
    type: int
    default: 1
    inputBinding:
      prefix: --outFilterMultimapScoreRange

  - id: outFilterMultimapNmax
    type: int
    default: 10
    inputBinding:
      prefix: --outFilterMultimapNmax

  - id: outFilterMismatchNmax
    type: int
    default: 10
    inputBinding:
      prefix: --outFilterMismatchNmax

  - id: outFilterMismatchNoverLmax
    type: float
    default: 0.3
    inputBinding:
      prefix: --outFilterMismatchNoverLmax

  - id: outFilterMismatchNoverReadLmax
    type: float
    default: 1.0
    inputBinding:
      prefix: --outFilterMismatchNoverReadLmax

  - id: outFilterScoreMin
    type: int
    default: 0
    inputBinding:
      prefix: --outFilterScoreMin

  - id: outFilterScoreMinOverLread
    type: float
    default: 0.66
    inputBinding:
      prefix: --outFilterScoreMinOverLread

  - id: outFilterMatchNmin
    type: int
    default: 0
    inputBinding:
      prefix: --outFilterMatchNmin

  - id: outFilterMatchNminOverLread
    type: float
    default: 0.66
    inputBinding:
      prefix: --outFilterMatchNminOverLread

  - id: outFilterIntronMotifs
    type: string
    default: "None"
    inputBinding:
      prefix: --outFilterIntronMotifs

  - id: outSJfilterReads
    type: string
    default: "All"
    inputBinding:
      prefix: --outSJfilterReads

  - id: outSJfilterOverhangMin
    type:
      type: array
      items: int
    default: [30, 12, 12, 12]
    inputBinding:
      prefix: --outSJfilterOverhangMin
      itemSeparator: " "

  - id: outSJfilterCountUniqueMin
    type:
      type: array
      items: int
    default: [3, 1, 1, 1]
    inputBinding:
      prefix: --outSJfilterCountUniqueMin
      itemSeparator: " "

  - id: outSJfilterCountTotalMin
    type:
      type: array
      items: int
    default: [3, 1, 1, 1]
    inputBinding:
      prefix: --outSJfilterCountTotalMin
      itemSeparator: " "

  - id: outSJfilterDistToOtherSJmin
    type:
      type: array
      items: int
    default: [10, 0, 5, 10]
    inputBinding:
      prefix: --outSJfilterDistToOtherSJmin
      itemSeparator: " "

  - id: outSJfilterIntronMaxVsReadN
    type:
      type: array
      items: int
    default: [50000, 100000, 200000]
    inputBinding:
      prefix: --outSJfilterIntronMaxVsReadN
      itemSeparator: " "

  - id: scoreGap
    type: int
    default: 0
    inputBinding:
      prefix: --scoreGap

  - id: scoreGapNoncan
    type: int
    default: -8
    inputBinding:
      prefix: --scoreGapNoncan

  - id: scoreGapGCAG
    type: int
    default: -4
    inputBinding:
      prefix: --scoreGapGCAG

  - id: scoreGapATAC
    type: int
    default: -8
    inputBinding:
      prefix: --scoreGapATAC

  - id: scoreGenomicLengthLog2scale
    type: float
    default: -0.25
    inputBinding:
      prefix: --scoreGenomicLengthLog2scale

  - id: scoreDelOpen
    type: int
    default: -2
    inputBinding:
      prefix: --scoreDelOpen

  - id: scoreDelBase
    type: int
    default: -2
    inputBinding:
      prefix: --scoreDelBase

  - id: scoreInsOpen
    type: int
    default: -2
    inputBinding:
      prefix: --scoreInsOpen

  - id: scoreInsBase
    type: int
    default: -2
    inputBinding:
      prefix: --scoreInsBase

  - id: scoreStitchSJshift
    type: int
    default: 1
    inputBinding:
      prefix: --scoreStitchSJshift

  - id: seedSearchStartLmax
    type: int
    default: 50
    inputBinding:
      prefix: --seedSearchStartLmax

  - id: seedSearchStartLmaxOverLread
    type: float
    default: 1.0
    inputBinding:
      prefix: --seedSearchStartLmaxOverLread

  - id: seedSearchLmax
    type: int
    default: 0
    inputBinding:
      prefix: --seedSearchLmax

  - id: seedMultimapNmax
    type: int
    default: 10000
    inputBinding:
      prefix: --seedMultimapNmax

  - id: seedPerReadNmax
    type: int
    default: 1000
    inputBinding:
      prefix: --seedPerReadNmax

  - id: seedPerWindowNmax
    type: int
    default: 50
    inputBinding:
      prefix: --seedPerWindowNmax

  - id: seedNoneLociPerWindow
    type: int
    default: 10
    inputBinding:
      prefix: --seedNoneLociPerWindow

  - id: alignIntronMin
    type: int
    default: 21
    inputBinding:
      prefix: --alignIntronMin

  - id: alignIntronMax
    type: int
    default: 0
    inputBinding:
      prefix: --alignIntronMax

  - id: alignMatesGapMax
    type: int
    default: 0
    inputBinding:
      prefix: --alignMatesGapMax

  - id: alignSJoverhangMin
    type: int
    default: 5
    inputBinding:
      prefix: --alignSJoverhangMin
      
  - id: alignSJstitchMismatchNmax
    type:
      type: array
      items: int
    default: [0, -1, 0, 0]
    inputBinding:
      prefix: --alignSJstitchMismatchNmax
      itemSeparator: " "

  - id: alignSJDBoverhangMin
    type: int
    default: 3
    inputBinding:
      prefix: --alignSJDBoverhangMin

  - id: alignSplicedMateMapLmin
    type: int
    default: 0
    inputBinding:
      prefix: --alignSplicedMateMapLmin

  - id: alignSplicedMateMapLminOverLmate
    type: float
    default: 0.66
    inputBinding:
      prefix: --alignSplicedMateMapLminOverLmate

  - id: alignWindowsPerReadNmax
    type: int
    default: 10000
    inputBinding:
      prefix: --alignWindowsPerReadNmax

  - id: alignTranscriptsPerWindowNmax
    type: int
    default: 100
    inputBinding:
      prefix: --alignTranscriptsPerWindowNmax

  - id: alignTranscriptsPerReadNmax
    type: int
    default: 10000
    inputBinding:
      prefix: --alignTranscriptsPerReadNmax

  - id: alignEndsType
    type: string
    default: "Local"
    inputBinding:
      prefix: --alignEndsType

  - id: alignEndsProtrude
    type:
      type: array
      items: string
    default: ["0", "ConcordantPair"]
    inputBinding:
      prefix: --alignEndsProtrude
      itemSeparator: " "

  - id: alignSoftClipAtReferenceEnds
    type: string
    items: "Yes"
    inputBinding:
      prefix: --alignSoftClipAtReferenceEnds

  - id: winAnchorMultimapNmax
    type: int
    default: 50
    inputBinding:
      prefix: --winAnchorMultimapNmax

  - id: winBinNbits
    type: int
    default: 16
    inputBinding:
      prefix: --winBinNbits

  - id: winAnchorDistNbins
    type: int
    default: 9
    inputBinding:
      prefix: --winAnchorDistNbins

  - id: winFlankNbins
    type: int
    default: 4
    inputBinding:
      prefix: --winFlankNbins


  - id: winReadCoverageRelativeMin
    type: float
    default: 0.5
    inputBinding:
      prefix: --winReadCoverageRelativeMin

  - id: winReadCoverageBasesMin
    type: int
    default: 0
    inputBinding:
      prefix: --winReadCoverageBasesMin

  - id: chimOutType
    type: string
    default: "SeparateSAMold"
    inputBinding:
      prefix: --chimOutType

  - id: chimSegmentMin
    type: int
    default: 0
    inputBinding:
      prefix: --chimSegmentMin

  - id: chimScoreMin
    type: int
    default: 0
    inputBinding:
      prefix: --chimScoreMin

  - id: chimScoreDropMax
    type: int
    default: 20
    inputBinding:
      prefix: --chimScoreDropMax

  - id: chimScoreSeparation
    type: int
    default: 10
    inputBinding:
      prefix: --chimScoreSeparation

  - id: chimScoreJunctionNonGTAG
    type: int
    default: -1
    inputBinding:
      prefix: --chimScoreJunctionNonGTAG

  - id: chimJunctionOverhangMin
    type: int
    default: 20
    inputBinding:
      prefix: --chimJunctionOverhangMin

  - id: chimSegmentReadGapMax
    type: int
    default: 0
    inputBinding:
      prefix: --chimSegmentReadGapMax

  - id: chimFilter
    type: string
    default: "banGenomicN"
    inputBinding:
      prefix: --chimFilter

  - id: chimMainSegmentMultNmax
    type: int
    default: 10
    inputBinding:
      prefix: --chimMainSegmentMultNmax

  - id: quantMode
    type: string
    default: "-"
    inputBinding:
      prefix: --quantMode

  - id: quantTranscriptomeBAMcompression
    type: int
    default: 1
    inputBinding:
      prefix: --quantTranscriptomeBAMcompression
      
  - id: quantTranscriptomeBan
    type: string
    default: "IndelSoftclipSingleend"
    inputBinding:
      prefix: --quantTranscriptomeBan

  - id: twopassMode
    type: string
    default: "None"
    inputBinding:
      prefix: --twopassMode

  - id: twopass1readsN
    type: int
    default: -1
    inputBinding:
      prefix: --twopass1readsN
      
    
outputs:
  []

baseCommand: [/usr/local/bin/STAR]
