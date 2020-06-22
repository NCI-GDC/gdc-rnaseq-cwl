cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_star_align_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl
      - $import: ../../../tools/star_results.cwl

inputs:
  readgroup_fastq_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
  genomeDir: Directory
  threads: int?
  job_uuid: string

outputs:
  star_outputs:
    type: ../../../tools/star_results.cwl#star_results
    outputSource: makeStarOutputs/output

steps:
  makePrefix:
    run:
      id: makeStarPrefix
      class: ExpressionTool
      inputs:
        job_uuid: string
        fastq_list:
          type: 
            type: array
            items: ../../../tools/readgroup.cwl#readgroup_fastq_file
      outputs:
        output: string
        is_paired: boolean
      expression: |
        ${
           var output = inputs.job_uuid;
           var is_paired = false;

           if( inputs.fastq_list[0].reverse_fastq !== null ) {
             output = output + '.pe';
             is_paired = true;
           } else {
             output = output + '.se' 
           }
           return {'output': output, 'is_paired': is_paired}
         }
    in:
      job_uuid: job_uuid
      fastq_list: readgroup_fastq_file_list
    out: [ output, is_paired ]

  starAlign:
    run: ../../../tools/star_align.cwl
    in:
      readgroup_fastq_file_list: readgroup_fastq_file_list
      genomeDir: genomeDir
      readFilesCommand:
        default: "zcat"
      runThreadN: threads
      outFileNamePrefix:
        source: makePrefix/output 
        valueFrom: $(self + '.')
    out:
      - log_progress_out
      - log_out
      - log_final_out
      - genomic_bam_out
      - junctions_out
      - transcriptome_bam_out
      - chimeric_sam_out
      - chimeric_junctions
      - gene_counts
      - star_pass1_genome
      - star_pass1

  chimericSamToBam:
    run: ../../../tools/samtools_sam2bam.cwl
    in:
      input_sam: starAlign/chimeric_sam_out
      output_filename:
        source: makePrefix/output 
        valueFrom: "$(self + '.chimeric.bam')"
      threads: threads
    out: [ bam ]

  chimericProcessedBam:
    run: ../utils/sort_and_index_workflow.cwl
    in:
      input_bam: chimericSamToBam/bam
      output_prefix:
        source: makePrefix/output 
        valueFrom: "$(self + '.chimeric')"
      threads: threads
    out: [ processed_bam ]

  genomicProcessedBam:
    run: ../utils/sort_and_index_workflow.cwl
    in:
      input_bam: starAlign/genomic_bam_out
      output_prefix:
        source: makePrefix/output 
        valueFrom: "$(self + '.genome')"
      threads: threads
    out: [ processed_bam ]

  archiveDirectories:
    run: ../../../tools/archive_directory.cwl
    scatter: input_directory
    in:
      input_directory: [starAlign/star_pass1_genome, starAlign/star_pass1]
    out: [ output_archive ]

  compressChimericJunctions:
    run: ../../../tools/gzip.cwl
    in:
      input_file: starAlign/chimeric_junctions
    out: [ output_file ]

  makeStarOutputs:
    run:
      id: makeStarOutputObject
      class: ExpressionTool
      inputs:
        star_stats_file:
          type: File
        star_junctions_file:
          type: File
        star_chimeric_junctions_file:
          type: File
        star_gene_counts_file:
          type: File
        star_genome_bam_file:
          type: File
        star_chimeric_bam_file:  
          type: File
        star_transcriptome_bam_file:
          type: File
        archived_other_directories_files:
          type: File[]
        is_paired_bool:
          type: boolean 
      outputs:
        output: ../../../tools/star_results.cwl#star_results 
      expression: |
        ${
           var data = {
             'star_stats': inputs.star_stats_file,
             'star_junctions': inputs.star_junctions_file,
             'star_chimeric_junctions': inputs.star_chimeric_junctions_file,
             'star_gene_counts': inputs.star_gene_counts_file,
             'star_genome_bam': inputs.star_genome_bam_file,
             'star_chimeric_bam': inputs.star_chimeric_bam_file,
             'star_transcriptome_bam': inputs.star_transcriptome_bam_file,
             'archived_other_directories': inputs.archived_other_directories_files,
             'is_paired': inputs.is_paired_bool
           }
           return {'output': data} 
         }
    in:
      star_stats_file: starAlign/log_final_out
      star_junctions_file: starAlign/junctions_out
      star_chimeric_junctions_file: compressChimericJunctions/output_file 
      star_gene_counts_file: starAlign/gene_counts
      star_genome_bam_file: genomicProcessedBam/processed_bam
      star_chimeric_bam_file: chimericProcessedBam/processed_bam
      star_transcriptome_bam_file: starAlign/transcriptome_bam_out
      archived_other_directories_files: archiveDirectories/output_archive
      is_paired_bool: makePrefix/is_paired 
    out: [ output ]
