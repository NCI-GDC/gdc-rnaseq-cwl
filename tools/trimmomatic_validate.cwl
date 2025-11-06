cwlVersion: v1.0
class: CommandLineTool
id: trimmomatic_validate
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/trimmomatic:{{ trimmomatic }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 4500 
    tmpdirMin: |
      ${
         var dat = [];
         for(var i = 0; i<inputs.readgroup_fastq_file.length; i++) {
           var curr = inputs.readgroup_fastq_file[i];
           dat.push(curr.forward_fastq)
           if(curr.reverse_fastq !== null) {
             dat.push(curr.reverse_fastq)
           }
         }
         return sum_file_array_size(dat)
       }
    outdirMin: |
      ${
         var dat = [];
         for(var i = 0; i<inputs.readgroup_fastq_file.length; i++) {
           var curr = inputs.readgroup_fastq_file[i];
           dat.push(curr.forward_fastq)
           if(curr.reverse_fastq !== null) {
             dat.push(curr.reverse_fastq)
           }
         }
         return sum_file_array_size(dat)
       }

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
                 var ofil = fbase + '_SE.fq.gz'
                 if( fdat.basename == ofil ) {
                   rec.forward_fastq = fdat
                 }
             }
           }
           return rec
         }
 
baseCommand: [java, -Xmx4G, -jar, /bin/trimmomatic.jar] 

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
           var ofil = inputs.readgroup_fastq_file.readgroup_meta.ID + '_SE.fq.gz'
           return ofil
         } else {
           return null
         }
       }
    position: 5

  - valueFrom: "TOPHRED33"
    position: 6
