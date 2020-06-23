cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_input_fastq_processing_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SchemaDefRequirement
    types:
      - $import: /tools/readgroup.cwl

inputs:
  readgroup_fastq_file:
    type: /tools/readgroup.cwl#readgroup_fastq_file

outputs:
  output_vendor_filtered_fq:
    type: /tools/readgroup.cwl#readgroup_fastq_file
    outputSource: emit_readgroup_fastq_file/output

steps:
  vendorfail_filter:
    run: /tools/fastq_vendor_fail_filter.cwl
    in:
      input_r1:
        source: readgroup_fastq_file
        valueFrom: $(self.forward_fastq)
      input_r2:
        source: readgroup_fastq_file
        valueFrom: $(self.reverse_fastq)
      output_prefix:
        source: readgroup_fastq_file
        valueFrom: $(self.readgroup_meta.ID + '_fqvendorfilter')
    out: [ output_r1, output_r2 ]

  emit_readgroup_fastq_file:
    run: /tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: vendorfail_filter/output_r1
      reverse_fastq: vendorfail_filter/output_r2
      readgroup_meta:
        source: readgroup_fastq_file
        valueFrom: $(self.readgroup_meta)
    out: [ output ]
