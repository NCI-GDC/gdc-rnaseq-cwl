cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_readgroup_bam_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl
  - class: StepInputExpressionRequirement

inputs:
  readgroup_bam_uuid:
    type: ../../../tools/readgroup.cwl#readgroup_bam_uuid
  bioclient_config: File

outputs:
  output:
    type: ../../../tools/readgroup.cwl#readgroup_bam_file
    outputSource: emit_readgroup_bam_file/output

steps:
  extract_bam:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_bam_uuid
        valueFrom: $(self.bam_uuid)
      file_size:
        source: readgroup_bam_uuid
        valueFrom: $(self.bam_file_size)
    out: [ output ]

  emit_readgroup_bam_file:
    run: ../../../tools/emit_readgroup_bam_file.cwl
    in:
      bam: extract_bam/output
      readgroup_meta_list:
        source: readgroup_bam_uuid
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]
