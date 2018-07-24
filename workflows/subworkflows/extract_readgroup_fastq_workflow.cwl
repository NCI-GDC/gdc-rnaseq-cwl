cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.cwl
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  readgroup_fastq_uuid:
    type: ../../tools/readgroup.cwl#readgroup_fastq_uuid
  bioclient_config: File

outputs:
  output:
    type: ../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: emit_readgroup_fastq_file/output

steps:
  extract_forward_fastq:
    run: ../../tools/bioclient_download.cwl
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
    run: ../../tools/bioclient_conditional_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_fastq_uuid
        valueFrom: $(self.reverse_fastq_uuid)
      file_size:
        source: readgroup_fastq_uuid
        valueFrom: $(self.reverse_fastq_file_size)
    out: [ output ]

  vendorfail_filter:
    run: ../../tools/fastq_vendor_fail_filter.cwl
    in:
      input_r1: extract_forward_fastq/output
      input_r2: extract_reverse_fastq/output
      output_prefix:
        source: readgroup_fastq_uuid
        valueFrom: $(self.readgroup_meta.ID + '_fqvendorfilter')
    out: [ output_r1, output_r2 ]
      
  emit_readgroup_fastq_file:
    run: ../../tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: vendorfail_filter/output_r1
      reverse_fastq: vendorfail_filter/output_r2
      readgroup_meta:
        source: readgroup_fastq_uuid
        valueFrom: $(self.readgroup_meta)
    out: [ output ]
