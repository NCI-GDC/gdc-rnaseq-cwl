#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    coresMax: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 2000
    ramMax: 2000
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl

inputs:
  threads:
    type: int?
    inputBinding:
      prefix: -threads
      position: 1

  readgroup_fastq_file:
    type: readgroup.cwl#readgroup_fastq_file
  
outputs:
  output:
    type: readgroup.cwl#readgroup_fastq_file
    outputBinding:
      glob: $(inputs.readgroup_fastq_file.readgroup_meta.ID + '*')
      outputEval: |
        ${
           var fbase = inputs.readgroup_fastq_file.readgroup_meta.ID
           var rec = {
             "forward_fastq": null,
             "reverse_fastq": null,
             "readgroup_meta": inputs.readgroup_fastq_file.readgroup_meta
           }

           for(var i = 0; i < self.length; i++) {
             var fdat = self[i]
             if( inputs.readgroup_fastq_file.reverse_fastq !== null) {
                 if(fdat.basename == fbase + '_1P.fq.gz') {
                   rec.forward_fastq = fdat
                 } 
                 else if( fdat.basename == fbase + '_2P.fq.gz' ) {
                   rec.reverse_fastq = fdat
                 }
             } else {
                 var idx = inputs.readgroup_fastq_file.forward_fastq.nameroot.lastIndexOf('.')
                 var ofil = inputs.readgroup_fastq_file.forward_fastq.nameroot.slice(0, idx) + '_SE.fq.gz' 
                 if( fdat.basename == ofil ) {
                   rec.forward_fastq = fdat
                 }
             }
           }
           return rec
         }
 
baseCommand: [java, -jar, /mnt/SCRATCH/software/trimmomatic/Trimmomatic-0.36/trimmomatic-0.36.jar]

arguments:
  - valueFrom: |
      ${
         return inputs.readgroup_fastq_file.reverse_fastq !== null ? 'PE' : 'SE'
       }
    position: 0

  - valueFrom: |
      ${
         if( inputs.readgroup_fastq_file.reverse_fastq !== null ) {
           return inputs.readgroup_fastq_file.readgroup_meta.ID + '.fq.gz'
         } else {
           return null
         }
       }
    prefix: -baseout
    position: 2

  - valueFrom: |
      ${
         if( inputs.readgroup_fastq_file.reverse_fastq !== null ) {
           return '-validatePairs' 
         }
         else {
           return null
         }
       }
    position: 3

  - valueFrom: |
      ${
         if( inputs.readgroup_fastq_file.reverse_fastq !== null ) {
           return [inputs.readgroup_fastq_file.forward_fastq.path, inputs.readgroup_fastq_file.reverse_fastq.path]
         }
         else {
           return inputs.readgroup_fastq_file.forward_fastq.path 
         }
       }
    position: 4

  - valueFrom: |
      ${
         if( inputs.readgroup_fastq_file.reverse_fastq === null) {
           var idx = inputs.readgroup_fastq_file.forward_fastq.nameroot.lastIndexOf('.')
           var ofil = inputs.readgroup_fastq_file.forward_fastq.nameroot.slice(0, idx) + '_SE.fq.gz' 
           return ofil
         } else {
           return null
         }
       }
    position: 5

  - valueFrom: "TOPHRED33"
    position: 6
