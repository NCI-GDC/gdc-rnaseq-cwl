cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.cwl

inputs:
  threads: int?
  job_uuid: string
  readgroup_fastq_file_list:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
  #readgroup_fastq_se_file_list:
  #  type:
  #    type: array
  #    items: ../../tools/readgroup.cwl#readgroup_fastq_file

outputs:
  output_fq:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: trimmomatic_convert/output
  #output_pe:
  #  type:
  #    type: array
  #    items: ../../tools/readgroup.cwl#readgroup_fastq_file
  #  outputSource: trimmomatic_convert_pe/output

  #output_se:
  #  type:
  #    type: array
  #    items: ../../tools/readgroup.cwl#readgroup_fastq_file
  #  outputSource: trimmomatic_convert_se/output

  output_fastqc:
    type: 
      type: array
      items:
        type: array
        items: File
    outputSource: run_fastqc/OUTPUT 
  #fastqc_pe:
  #  type: 
  #    type: array
  #    items:
  #      type: array
  #      items: File
  #  outputSource: run_fastqc_pe/OUTPUT 
  #fastqc_se:
  #  type: 
  #    type: array
  #    items:
  #      type: array
  #      items: File
  #  outputSource: run_fastqc_se/OUTPUT 

steps:
  trimmomatic_convert: 
    run: ../../tools/trimmomatic_validate.cwl
    scatter: readgroup_fastq_file
    in:
      readgroup_fastq_file: readgroup_fastq_file_list
      threads: 
        source: threads
        default: 1
    out: [ output ]

  run_fastqc:
    run: ../../tools/fastqc.cwl
    scatter: INPUT 
    in:
      INPUT:
        source: readgroup_fastq_file_list
        valueFrom: |
          ${
             var curr = [self.forward_fastq]
             if(self.reverse_fastq !== null) {
               curr.push(self.reverse_fastq)
             }
             return curr 
           }
      nogroup:
        default: true
      threads:
        source: threads
        default: 1
    out: [ OUTPUT ]

  #trimmomatic_convert_pe: 
  #  run: ../../tools/trimmomatic_validate.cwl
  #  scatter: readgroup_fastq_file 
  #  in:
  #    readgroup_fastq_file: readgroup_fastq_pe_file_list
  #    threads: 
  #      source: threads
  #      default: 1
  #  out: [ output ]

  #run_fastqc_pe:
  #  run: ../../tools/fastqc.cwl
  #  scatter: INPUT 
  #  in:
  #    INPUT:
  #      source: readgroup_fastq_pe_file_list
  #      valueFrom: |
  #        ${
  #           var curr = [self.forward_fastq, self.reverse_fastq]
  #           return curr 
  #         }
  #    nogroup:
  #      default: true
  #    threads:
  #      source: threads
  #      default: 1
  #  out: [ OUTPUT ]

  #trimmomatic_convert_se: 
  #  run: ../../tools/trimmomatic_validate.cwl
  #  scatter: readgroup_fastq_file 
  #  in:
  #    readgroup_fastq_file: readgroup_fastq_se_file_list
  #    threads:
  #      source: threads
  #      default: 1
  #  out: [ output ]

  #run_fastqc_se:
  #  run: ../../tools/fastqc.cwl
  #  scatter: INPUT 
  #  in:
  #    INPUT:
  #      source: readgroup_fastq_se_file_list
  #      valueFrom: |
  #        ${
  #           var fqlist = []
  #           for(var i = 0; i<self.length; i++) {
  #             var rec = self[i]
  #             var curr = [rec.foward_fastq]
  #             fqlist.push(curr)
  #           }
  #           return fqlist 
  #         }
  #    nogroup:
  #      default: true
  #    threads:
  #      source: threads
  #      default: 1
  #  out: [ OUTPUT ]
