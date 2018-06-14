#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: ShellCommandRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/star2@sha256:4fae62143d57ce66b768b4f654b4d5cf28dc116fa969974191eb75d43450ef0c
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.runThreadN ? inputs.runThreadN : 1)"
    ramMin: 60000
    tmpdirMin: $(star_size_est(inputs))
    outdirMin: $(star_size_est(inputs))

class: CommandLineTool

inputs:
  readgroup_fastq_file_list:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

  readgroup_keys:
    type:
      type: array
      items: string
    default: ["ID", "SM", "LB", "PU", "PL", "CN", "DT", "FO", "KS", "PI", "PM", "DS"]

  genomeDir:
    type: Directory
    doc: Genome directory
    inputBinding:
      prefix: --genomeDir

  readFilesCommand:
    type: string?
    inputBinding:
      prefix: --readFilesCommand

  runThreadN:
    type: int?
    doc: number of threads to use
    inputBinding:
      prefix: --runThreadN

  twopassMode:
    type: string?
    default: Basic
    inputBinding:
      prefix: --twopassMode

  outFilterMultimapNmax:
    type: int?
    default: 20
    inputBinding:
      prefix: --outFilterMultimapNmax

  alignSJoverhangMin:
    type: int?
    default: 8
    inputBinding:
      prefix: --alignSJoverhangMin

  alignSJDBoverhangMin:
    type: int?
    default: 1
    inputBinding:
      prefix: --alignSJDBoverhangMin

  outFilterMismatchNmax:
    type: int?
    default: 999
    inputBinding:
      prefix: --outFilterMismatchNmax

  outFilterMismatchNoverLmax:
    type: float?
    default: 0.1
    inputBinding:
      prefix: --outFilterMismatchNoverLmax

  alignIntronMin:
    type: int?
    default: 20
    inputBinding:
      prefix: --alignIntronMin

  alignIntronMax:
    type: int?
    default: 1000000
    inputBinding:
      prefix: --alignIntronMax

  alignMatesGapMax:
    type: int?
    default: 1000000
    inputBinding:
      prefix: --alignMatesGapMax

  outFilterType:
    type: string?
    default: BySJout
    inputBinding:
      prefix: --outFilterType

  outFilterScoreMinOverLread:
    type: float?
    default: 0.33
    inputBinding:
      prefix: --outFilterScoreMinOverLread

  outFilterMatchNminOverLread:
    type: float?
    default: 0.33
    inputBinding:
      prefix: --outFilterMatchNminOverLread

  limitSjdbInsertNsj:
    type: int?
    default: 1200000
    inputBinding:
      prefix: --limitSjdbInsertNsj

  outFileNamePrefix:
    type: string?
    inputBinding:
      prefix: --outFileNamePrefix

  outSAMstrandField:
    type: string?
    default: intronMotif
    inputBinding:
      prefix: --outSAMstrandField

  outFilterIntronMotifs:
    type: string?
    default: None
    inputBinding:
      prefix: --outFilterIntronMotifs

  alignSoftClipAtReferenceEnds:
    type: string?
    default: Yes
    inputBinding:
      prefix: --alignSoftClipAtReferenceEnds

  quantMode:
    type: string[]?
    default: [TranscriptomeSAM, GeneCounts]
    inputBinding:
      prefix: --quantMode 

  outSAMtype:
    type: string[]?
    default: [BAM, Unsorted]
    inputBinding:
      prefix: --outSAMtype

  outSAMunmapped:
    type: string?
    default: Within
    inputBinding:
      prefix: --outSAMunmapped

  genomeLoad:
    type: string?
    default: NoSharedMemory
    inputBinding:
      prefix: --genomeLoad

  chimSegmentMin:
    type: int?
    default: 15
    inputBinding:
      prefix: --chimSegmentMin

  chimJunctionOverhangMin:
    type: int?
    default: 15
    inputBinding:
      prefix: --chimJunctionOverhangMin

  chimOutType:
    type: string[]?
    default: [Junctions, SeparateSAMold, WithinBAM, SoftClip]
    inputBinding:
      prefix: --chimOutType

  chimMainSegmentMultNmax:
    type: int? 
    default: 1
    inputBinding:
      prefix: --chimMainSegmentMultNmax

  outSAMattributes:
    type: string[]?
    default: [NH, HI, AS, nM, NM, ch]
    inputBinding:
      prefix: --outSAMattributes

outputs:
  log_progress_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Log.progress.out';
         }

  log_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Log.out';
         }

  log_final_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Log.final.out';
         }

  genomic_bam_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Aligned.out.bam';
         }

  junctions_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'SJ.out.tab';
         }

  transcriptome_bam_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Aligned.toTranscriptome.out.bam';
         }

  chimeric_sam_out:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Chimeric.out.sam';
         }
  
  chimeric_junctions:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'Chimeric.out.junction';
         }

  gene_counts:
    type: File
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + 'ReadsPerGene.out.tab';
         }

  star_pass1_genome:
    type: Directory
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + '_STARgenome';
         }

  star_pass1:
    type: Directory
    outputBinding:
      glob: |
        ${
           var pfx = inputs.outFileNamePrefix ? inputs.outFileNamePrefix : '';
           return pfx + '_STARpass1';
         }

baseCommand: [STAR, ]

arguments:
  - valueFrom: |
        ${
           var r1 = [];
           var r2 = [];
           var rgs = [];
           for(var i = 0; i < inputs.readgroup_fastq_file_list.length; i++) {
             // Make readgroup
             var currRg = [];
             var val = inputs.readgroup_fastq_file_list[i]
             for(var j = 0; j < inputs.readgroup_keys.length; j++) {
                 var rgkey = inputs.readgroup_keys[j] 
                 if( val.readgroup_meta[rgkey] !== null ) {
                     currRg.push(rgkey + ':' + val.readgroup_meta[rgkey]);
                 }
             }
             rgs.push( currRg.join(" ") );
             r1.push( val.forward_fastq.path );
             if ( val.reverse_fastq !== null ) { r2.push( val.reverse_fastq.path ); }
           }
           // input files
           var inputFiles = ['--readFilesIn'];
           if(r1.length > 0) {inputFiles.push(r1.join(","))};
           if(r2.length > 0) {inputFiles.push(r2.join(","))};

           //rgattrs
           var rgAttrs = ' --outSAMattrRGline ' + rgs.join(" , ");
           return inputFiles.join(' ') + rgAttrs; 
         }
    position: 0
    shellQuote: false
