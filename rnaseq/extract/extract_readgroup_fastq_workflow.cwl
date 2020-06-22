cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_extract_readgroup_fastq_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  readgroup_fastq_uuid:
    type: ../../../tools/readgroup.cwl#readgroup_fastq_uuid
  bioclient_config: File

outputs:
  output:
    type: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: emit_readgroup_fastq_file/output

steps:
  extract_forward_fastq:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_fastq_uuid
        valueFrom: $(self.forward_fastq_uuid)
      file_size:
        source: readgroup_fastq_uuid
        valueFrom: $(self.forward_fastq_file_size)
    out: [ output ]
    
  extract_reverse_fastq:
    run: ../../../tools/bioclient_conditional_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_fastq_uuid
        valueFrom: $(self.reverse_fastq_uuid)
      file_size:
        source: readgroup_fastq_uuid
        valueFrom: $(self.reverse_fastq_file_size)
    out: [ output ]

  emit_readgroup_fastq_file:
    run: ../../../tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: extract_forward_fastq/output
      reverse_fastq: extract_reverse_fastq/output
      readgroup_meta:
        source: readgroup_fastq_uuid
        valueFrom: $(self.readgroup_meta)
    out: [ output ]
