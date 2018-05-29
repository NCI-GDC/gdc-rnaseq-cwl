cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../tools/readgroup.cwl
      - $import: ../tools/star_results.cwl

inputs:
  bioclient_config: File
  upload_bucket: string
  threads: int?
  genomeDir: Directory
  ribosome_intervals: File?
  ref_flat: File
  job_uuid: string
  readgroup_bam_file_list:
    type:
      type: array
      items: ../tools/readgroup.cwl#readgroup_bam_file
  readgroup_fastq_file_list:
    type:
      type: array
      items: ../tools/readgroup.cwl#readgroup_fastq_file
  #readgroup_fastq_uuid_list:
  #  type:
  #    type: array
  #    items: ../tools/readgroup.cwl#readgroup_fastq_uuid
  #readgroup_bam_uuid_list:
  #  type:
  #    type: array
  #    items: ../tools/readgroup.cwl#readgroup_fastq_uuid

outputs:
  harmonization_metrics_uuid:
    type: string
    outputSource: determine_outputs/metrics_db_uuid 

  star_genomic_bam_uuid:
    type: string
    outputSource: determine_outputs/genomic_bam_uuid 

  star_genomic_bai_uuid:
    type: string
    outputSource: determine_outputs/genomic_bai_uuid 

  star_transcriptome_bam_uuid:
    type: string?
    outputSource: determine_outputs/transcriptome_bam_uuid

  star_chimeric_bam_uuid:
    type: string?
    outputSource: determine_outputs/chimeric_bam_uuid

  star_chimeric_bai_uuid:
    type: string?
    outputSource: determine_outputs/chimeric_bai_uuid

  star_chimeric_tsv_uuid:
    type: string?
    outputSource: determine_outputs/chimeric_tsv_uuid

  star_gene_counts_uuid:
    type: string
    outputSource: determine_outputs/gene_counts_uuid

  star_junctions_tsv_uuid:
    type: string
    outputSource: determine_outputs/junctions_tsv_uuid

  star_archive_uuid:
    type: string
    outputSource: determine_outputs/archive_uuid

steps:
  #extract_readgroup_fastq_pe:
  #  run: ./subworkflows/extract_readgroup_fastq_pe.cwl
  #  scatter: readgroup_fastq_pe_uuid_list
  #  in:
  #    readgroup_fastq_pe_uuid: readgroup_fastq_pe_uuid_list
  #    bioclient_config: bioclient_config
  #  out: [ output ] 
  process_bam_files:
    run: ./subworkflows/input_bam_processing_workflow.cwl
    scatter: readgroups_bam_file
    in:
      readgroups_bam_file: readgroup_bam_file_list
    out: [ pe_file_list, se_file_list, o1_file_list, o2_file_list ]

  run_merge_fastq_array_workflow:
    run: ./subworkflows/merge_fastq_arrays_workflow.cwl
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
    run: ./subworkflows/fastq_processing_workflow.cwl
    in:
      threads: threads
      job_uuid: job_uuid
      readgroup_fastq_file_list: run_merge_fastq_array_workflow/fastq_array
    out: [ output_fq, output_fastqc ]

  split_fastq_array:
    run: ../tools/split_fastq_array.cwl
    in:
      fastq_list: process_fastq_files/output_fq
    out: [ output ]

  run_star2pass:
    run: ./subworkflows/star_align_workflow.cwl
    scatter: readgroup_fastq_file_list
    in:
      readgroup_fastq_file_list: split_fastq_array/output
      genomeDir: genomeDir
      threads: threads
      job_uuid: job_uuid
    out: [ star_outputs ]

  run_merge_genome_bams:
    run: ./subworkflows/merge_and_index_workflow.cwl
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
        valueFrom: $(self + '.rna_seq.gdc_realn.bam')
      threads: threads
    out: [ merged_bam ]

  run_collect_metrics:
    run: ./subworkflows/rnaseq_metrics_workflow.cwl
    in:
      threads: threads
      ref_flat: ref_flat
      ribosome_intervals: ribosome_intervals
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

  determine_outputs:
    run: ./subworkflows/determine_outputs_workflow.cwl
    in:
      metrics_db: run_collect_metrics/metrics_db
      star_results: run_star2pass/star_outputs
      genome_bam: run_merge_genome_bams/merged_bam
      job_uuid: job_uuid
      bioclient_config: bioclient_config
      upload_bucket: upload_bucket
    out:
      - metrics_db_uuid
      - genomic_bam_uuid
      - genomic_bai_uuid
      - transcriptome_bam_uuid
      - chimeric_bam_uuid
      - chimeric_bai_uuid
      - chimeric_tsv_uuid
      - gene_counts_uuid
      - junctions_tsv_uuid
      - archive_uuid