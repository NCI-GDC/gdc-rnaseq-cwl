cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_load_outputs_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/star_results.cwl

inputs:
  metrics_db: File
  gene_counts: File
  junctions: File
  transcriptome_bam: File?
  chimeric_bam: File?
  chimeric_tsv: File?
  genome_bam: File
  archive_file: File
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
  upload_sqlite:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, metrics_db ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: metrics_db 
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

  upload_gene_counts:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, gene_counts ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: gene_counts
    out: [ output, uuid ]

  upload_junctions:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, junctions ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: junctions
    out: [ output, uuid ]

  upload_archive:
    run: ../../../tools/bioclient_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: [ job_uuid, archive_file ]
        valueFrom: $(self[0] + '/' + self[1].basename)
      input: archive_file
    out: [ output, uuid ]

  upload_transcriptome_bam:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: |
          ${
             return(self + '/' + self + '.rna_seq.transcriptome.gdc_realn.bam')
           }
      filename: 
        source: job_uuid
        valueFrom: |
          ${
             return(self + '.rna_seq.transcriptome.gdc_realn.bam')
           }
      input: transcriptome_bam
    out: [ uuid ]

  upload_chimeric_bam:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: |
          ${
             return(self + '/' + self + '.rna_seq.chimeric.gdc_realn.bam')
           }
      filename: 
        source: job_uuid
        valueFrom: |
          ${
             return(self + '.rna_seq.chimeric.gdc_realn.bam')
           }
      input: chimeric_bam
    out: [ uuid ]

  upload_chimeric_bai:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: |
          ${
             return(self + '/' + self + '.rna_seq.chimeric.gdc_realn.bam.bai')
           }
      filename: 
        source: job_uuid
        valueFrom: |
          ${
             return(self + '.rna_seq.chimeric.gdc_realn.bam.bai')
           }
      input:
        source: chimeric_bam 
        valueFrom: |
          ${
             var ret = self === null ? self : self.secondaryFiles[0]
             return(ret)
           }
    out: [ uuid ]

  upload_chimeric_tsv:
    run: ../../../tools/bioclient_conditional_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      upload-bucket: upload_bucket
      upload-key:
        source: job_uuid
        valueFrom: |
          ${
             return(self + '/' + self + '.rna_seq.star_chimeric_junctions.tsv.gz')
           }
      filename: 
        source: job_uuid
        valueFrom: |
          ${
             return(self + '.rna_seq.star_chimeric_junctions.tsv.gz')
           }
      input: chimeric_tsv
    out: [ uuid ]
