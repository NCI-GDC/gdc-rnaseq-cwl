cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_make_final_outputs_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/star_results.cwl

inputs:
  metrics_db: File
  star_results:
    type:
      type: array
      items: ../../../tools/star_results.cwl#star_results
  job_uuid: string
  gencode_version: string

outputs:
  out_metrics_sqlite:
    type: File
    outputSource: rename_sqlite/out_file
  out_gene_counts:
    type: File
    outputSource: merge_gene_counts/output
  out_junctions:
    type: File
    outputSource: merge_junctions/output
  out_transcriptome_bam:
    type: File?
    outputSource: extract_other_star_outputs/output_transcriptome_bam
  out_chimeric_bam:
    type: File?
    outputSource: extract_other_star_outputs/output_chimeric_bam
  out_chimeric_tsv:
    type: File?
    outputSource: extract_other_star_outputs/output_chimeric_junctions
  out_star_archive:
    type: File
    outputSource: make_archive/output_archive 

steps:
  rename_sqlite:
    run: ../../../tools/rename_file.cwl
    in:
      input_file: metrics_db
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.harmonization_metrics.db')
    out: [ out_file ]

  merge_gene_counts:
    run: ../../../tools/star_merge_counts.cwl
    in:
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i = 0; i<self.length; i++) {
                 res.push(self[i].star_gene_counts)
             }
             return res
           }
      outfile:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.star_gene_counts.tsv.gz')
    out: [ output ]
  
  augment_gene_counts:
    run: ../../../tools/gdc_rnaseq_tool_augment_star_counts.cwl
    in:
      counts:
        source: merge_gene_counts/output
      output:
        source: job_uuid
        valueFrom: $(self + 'rna_seq.augmented_star_gene_counts.tsv.gz')
      gencode_version:
        source: gencode_version
      gene_info:
        source: gene_info
    out: [ output ]

  merge_junctions:
    run: ../../../tools/star_merge_junctions.cwl
    in:
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i = 0; i<self.length; i++) {
                 res.push(self[i].star_junctions)
             }
             return res
           }
      outfile:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.star_splice_junctions.tsv.gz')
    out: [ output ]

  extract_other_star_outputs:
    run: ../../../tools/decider_star_outputs.cwl
    in:
      star_results: star_results
    out: [ output_transcriptome_bam, output_chimeric_bam, output_chimeric_junctions ]

  make_archive:
    run: ../../../tools/archive_list.cwl
    in:
      input_files:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i = 0; i<self.length; i++) {
                 var curr = self[i];
                 res.push(curr.star_stats)
                 res.push(curr.star_junctions)
                 res.push(curr.star_gene_counts)
                 for(var j = 0; j<curr.archived_other_directories.length; j++) {
                     res.push(curr.archived_other_directories[j])
                 }
             }
             return res
           }
      output_archive_name:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.harmonization_archive.tar.gz')
    out: [ output_archive ]
