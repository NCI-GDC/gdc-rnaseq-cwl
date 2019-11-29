cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_main_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.cwl
      - $import: ../../tools/star_results.cwl

inputs:
  readgroup_bam_file_list:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_bam_file
  readgroup_fastq_file_list:
    type:
      type: array
      items: ../../tools/readgroup.cwl#readgroup_fastq_file
  ref_flat: File
  ribosome_intervals: File
  star_genome_dir: Directory
  threads: int?
  job_uuid: string
  picard_java_mem:
    type: int
    default: 4

outputs:
  out_metrics_db:
    type: File
    outputSource: run_collect_metrics/metrics_db
  out_star_result:
    type:
      type: array
      items: ../../tools/star_results.cwl#star_results
    outputSource: run_star2pass/star_outputs
  out_genome_bam:
    type: File
    outputSource: run_merge_genome_bams/merged_bam

steps:
  process_bam_files:
    run: ./preprocessing/input_bam_processing_workflow.cwl
    scatter: readgroups_bam_file
    in:
      readgroups_bam_file: readgroup_bam_file_list
    out: [ pe_file_list, se_file_list, o1_file_list, o2_file_list ]

  run_merge_fastq_array_workflow:
    run: ./utils/merge_fastq_arrays_workflow.cwl
    in:
      bam_pe_fastqs:
        linkMerge: merge_flattened
        source:
          - process_bam_files/pe_file_list
        valueFrom: $(self)
      bam_se_fastqs:
        linkMerge: merge_flattened
        source:
          - process_bam_files/se_file_list
        valueFrom: $(self)
      bam_o1_fastqs:
        linkMerge: merge_flattened
        source:
          - process_bam_files/o1_file_list
        valueFrom: $(self)
      bam_o2_fastqs:
        linkMerge: merge_flattened
        source:
          - process_bam_files/o2_file_list
        valueFrom: $(self)
      fastqs: readgroup_fastq_file_list
    out: [ fastq_array ]

  process_fastq_files:
    run: ./preprocessing/fastq_processing_workflow.cwl
    in:
      threads: threads
      job_uuid: job_uuid
      readgroup_fastq_file_list: run_merge_fastq_array_workflow/fastq_array
    out: [ output_fq, output_fastqc ]

  split_fastq_array:
    run: ../../tools/split_fastq_array.cwl
    in:
      fastq_list: process_fastq_files/output_fq
    out: [ output ]

  run_star2pass:
    run: ./rnaseq_processing/star_align_workflow.cwl
    scatter: readgroup_fastq_file_list
    in:
      readgroup_fastq_file_list: split_fastq_array/output
      genomeDir: star_genome_dir
      threads: threads
      job_uuid: job_uuid
    out: [ star_outputs ]

  run_merge_genome_bams:
    run: ./utils/merge_and_index_workflow.cwl
    in:
      input_bam:
        source: run_star2pass/star_outputs
        valueFrom: |
          ${
             var res = [];
             for(var i=0; i<self.length; i++) {
                 res.push(self[i].star_genome_bam);
             }
             return res;
           }
      output_bam_name:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.genomic.gdc_realn.bam')
      threads: threads
    out: [ merged_bam ]

  run_collect_metrics:
    run: ./rnaseq_processing/rnaseq_metrics_workflow.cwl
    in:
      threads: threads
      ref_flat: ref_flat
      ribosome_intervals: ribosome_intervals
      picard_mem: picard_java_mem
      fastqc_files:
        source: process_fastq_files/output_fastqc
        valueFrom: |
          ${
             var res = [];
             for( var i = 0; i<self.length; i++) {
                 for( var j = 0; j<self[i].length; j++) {
                     res.push(self[i][j]);
                 }
             }
             return res;
           }
      genome_bam: run_merge_genome_bams/merged_bam
      star_results: run_star2pass/star_outputs
      job_uuid: job_uuid
    out: [ metrics_db ]
