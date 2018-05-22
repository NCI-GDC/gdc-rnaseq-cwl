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
  readgroup_fastq_pe_file_list:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
  readgroup_fastq_se_file_list:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file

outputs:
  output_pe:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: trimmomatic_convert_pe/output

  output_se:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: trimmomatic_convert_se/output

  fastqc_pe:
    type: 
      type: array
      items:
        type: array
        items: File
    outputSource: run_fastqc_pe/OUTPUT 
  fastqc_se:
    type: 
      type: array
      items:
        type: array
        items: File
    outputSource: run_fastqc_se/OUTPUT 

steps:
  trimmomatic_convert_pe: 
    run: ../../tools/trimmomatic_validate.cwl
    scatter: readgroup_fastq_file 
    in:
      readgroup_fastq_file: readgroup_fastq_pe_file_list
      threads: 
        source: threads
        default: 1
    out: [ output ]

  run_fastqc_pe:
    run: ../../tools/fastqc.cwl
    scatter: INPUT 
    in:
      INPUT:
        source: readgroup_fastq_pe_file_list
        valueFrom: |
          ${
             var curr = [self.forward_fastq, self.reverse_fastq]
             return curr 
           }
      nogroup:
        default: true
      threads:
        source: threads
        default: 1
    out: [ OUTPUT ]

  trimmomatic_convert_se: 
    run: ../../tools/trimmomatic_validate.cwl
    scatter: readgroup_fastq_file 
    in:
      readgroup_fastq_file: readgroup_fastq_se_file_list
      threads:
        source: threads
        default: 1
    out: [ output ]

  run_fastqc_se:
    run: ../../tools/fastqc.cwl
    scatter: INPUT 
    in:
      INPUT:
        source: readgroup_fastq_se_file_list
        valueFrom: |
          ${
             var fqlist = []
             for(var i = 0; i<self.length; i++) {
               var rec = self[i]
               var curr = [rec.foward_fastq]
               fqlist.push(curr)
             }
             return fqlist 
           }
      nogroup:
        default: true
      threads:
        source: threads
        default: 1
    out: [ OUTPUT ]

  #merge_fastqc:
  #  run:
  #    class: ExpressionTool
  #    inputs:
  #      fastqc:
  #        type:
  #          type: array
  #          items:
  #            type: array
  #            items: File
  #    outputs:
  #      fastqc_flattened:
  #        type:
  #          type: array
  #          items: File
  #    expression: |
  #      ${
  #         var ret = [];
  #         for (var i = 0; i < inputs.fastqc.length; i++) {
  #           var curr = inputs.fastqc[i]
  #           if(curr.constructor === Array) {
  #             for (var j = 0; j < curr.length; j++) {
  #               ret.push(curr[j])
  #             }
  #           } 
  #         }
  #         return {'fastqc_flattened': ret}
  #       }
  #  in:
  #    fastqc:
  #      linkMerge: merge_flattened
  #      source:
  #        - run_fastqc_pe/OUTPUT
  #        - run_fastqc_se/OUTPUT
  #  out: [ fastqc_flattened ]
 
  #run_fastqc_db:
  #  run: ../../tools/fastqc_db.cwl
  #  scatter: INPUT
  #  in:
  #    INPUT: merge_fastqc/fastqc_flattened 
  #    job_uuid: job_uuid
  #  out: [ LOG, OUTPUT ]

  #merge_sqlite:
  #  run: ../../tools/merge_sqlite.cwl
  #  in:
  #    source_sqlite: run_fastqc_db/OUTPUT
  #    job_uuid: job_uuid
  #  out: [ destination_sqlite, log ]
