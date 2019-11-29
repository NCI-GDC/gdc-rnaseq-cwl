cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_determine_outputs_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/star_results.cwl

inputs:
  metrics_db: File
  genome_bam: File
  star_results:
    type: 
      type: array
      items: ../../../tools/star_results.cwl#star_results
  job_uuid: string
  bioclient_config: File
  upload_bucket: string

outputs:
  metrics_db_uuid:
    type: string 
    outputSource: upload_sqlite/uuid

  genomic_bam_uuid:
    type: string 
    outputSource: upload_genome_bam/uuid

  genomic_bai_uuid:
    type: string 
    outputSource: upload_genome_bai/uuid

  transcriptome_bam_uuid:
    type: string?
    outputSource: upload_transcriptome_bam/uuid

  chimeric_bam_uuid:
    type: string?
    outputSource: upload_chimeric_bam/uuid

  chimeric_bai_uuid:
    type: string?
    outputSource: upload_chimeric_bai/uuid

  chimeric_tsv_uuid:
    type: string?
    outputSource: upload_chimeric_tsv/uuid

  gene_counts_uuid:
    type: string 
    outputSource: upload_gene_counts/uuid

  junctions_tsv_uuid:
    type: string 
    outputSource: upload_junctions/uuid

  archive_uuid:
    type: string 
    outputSource: upload_archive/uuid

steps:
  rename_sqlite:
    run: ../../../tools/rename_file.cwl
    in:
      input_file: metrics_db
      output_filename:
        source: job_uuid
        valueFrom: $(self + '.rna_seq.harmonization_metrics.db')
    out: [ out_file ]

  upload_sqlite:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, rename_sqlite/out_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: rename_sqlite/out_file
    out: [ output, uuid ]

  upload_genome_bam:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, genome_bam ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: genome_bam 
    out: [ output, uuid ]

  upload_genome_bai:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, genome_bam ]
        valueFrom: $(self[0] + '/' + self[1].secondaryFiles[0].basename)
      input:
        source: genome_bam
        valueFrom: $(self.secondaryFiles[0]) 
    out: [ output, uuid ]

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

  upload_gene_counts:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, merge_gene_counts/output ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: merge_gene_counts/output 
    out: [ output, uuid ]

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

  upload_junctions:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, merge_junctions/output ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: merge_junctions/output 
    out: [ output, uuid ]

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

  upload_archive:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, make_archive/output_archive ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: make_archive/output_archive 
    out: [ output, uuid ]

  upload_transcriptome_bam:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: $(self + '/' + self + '.rna_seq.transcriptome.gdc_realn.bam')
      filename: 
        source: job_uuid
        valueFrom: $(self + '.rna_seq.transcriptome.gdc_realn.bam')
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i=0; i<self.length; i++) {
               if(self[i].is_paired) {
                 res.push(self[i].star_transcriptome_bam)
               }
             }

             if(res.length == 0) {
               return null;
             } else if(res.length == 1) {
               return res[0]
             } else {
               throw "Multiple inputs not allowed!"
             }

           }
    out: [ uuid ]

  upload_chimeric_bam:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: $(self + '/' + self + '.rna_seq.chimeric.gdc_realn.bam')
      filename: 
        source: job_uuid
        valueFrom: $(self + '.rna_seq.chimeric.gdc_realn.bam')
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i=0; i<self.length; i++) {
               if(self[i].is_paired) {
                 res.push(self[i].star_chimeric_bam)
               }
             }

             if(res.length == 0) {
               return null;
             } else if(res.length == 1) {
               return res[0]
             } else {
               throw "Multiple inputs not allowed!"
             }

           }
    out: [ uuid ]

  upload_chimeric_bai:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: $(self + '/' + self + '.rna_seq.chimeric.gdc_realn.bam.bai')
      filename: 
        source: job_uuid
        valueFrom: $(self + '.rna_seq.chimeric.gdc_realn.bam.bai')
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i=0; i<self.length; i++) {
               if(self[i].is_paired) {
                 res.push(self[i].star_chimeric_bam.secondaryFiles[0])
               }
             }

             if(res.length == 0) {
               return null;
             } else if(res.length == 1) {
               return res[0]
             } else {
               throw "Multiple inputs not allowed!"
             }

           }
    out: [ uuid ]

  upload_chimeric_tsv:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: $(self + '/' + self + '.rna_seq.star_chimeric_junctions.tsv.gz')
      filename: 
        source: job_uuid
        valueFrom: $(self + '.rna_seq.star_chimeric_junctions.tsv.gz')
      input:
        source: star_results
        valueFrom: |
          ${
             var res = [];
             for(var i=0; i<self.length; i++) {
               if(self[i].is_paired) {
                 res.push(self[i].star_chimeric_junctions)
               }
             }

             if(res.length == 0) {
               return null;
             } else if(res.length == 1) {
               return res[0]
             } else {
               throw "Multiple inputs not allowed!"
             }

           }
    out: [ uuid ]
