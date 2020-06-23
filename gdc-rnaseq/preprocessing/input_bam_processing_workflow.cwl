cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_input_bam_processing_wf
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: /tools/readgroup.cwl
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  readgroups_bam_file:
    type: /tools/readgroup.cwl#readgroup_bam_file

outputs:
  pe_file_list:
    type:
      type: array
      items: /tools/readgroup.cwl#readgroup_fastq_file
    outputSource: decider_readgroup_pe/output
  se_file_list:
    type:
      type: array
      items: /tools/readgroup.cwl#readgroup_fastq_file
    outputSource: decider_readgroup_se/output
  o1_file_list:
    type:
      type: array
      items: /tools/readgroup.cwl#readgroup_fastq_file
    outputSource: decider_readgroup_o1/output
  o2_file_list:
    type:
      type: array
      items: /tools/readgroup.cwl#readgroup_fastq_file
    outputSource: decider_readgroup_o2/output

steps:
  biobambam_bamtofastq:
    run: /tools/biobambam2_bamtofastq.cwl
    in:
      filename:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
    out: [ output_fastq1, output_fastq2, output_fastq_o1,
           output_fastq_o2, output_fastq_s ]

  bam_readgroup_to_contents:
    run: /tools/bam_readgroup_to_contents.cwl
    in:
      INPUT:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
      MODE:
        default: "lenient"
    out: [ OUTPUT, log ]

  decider_readgroup_pe:
    run: /tools/decider_readgroup_expression.cwl
    in:
      forward_fastq_list: biobambam_bamtofastq/output_fastq1
      reverse_fastq_list: biobambam_bamtofastq/output_fastq2
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  decider_readgroup_se:
    run: /tools/decider_readgroup_expression.cwl
    in:
      forward_fastq_list: biobambam_bamtofastq/output_fastq_s
      reverse_fastq_list:
        default: []
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  decider_readgroup_o1:
    run: /tools/decider_readgroup_expression.cwl
    in:
      forward_fastq_list: biobambam_bamtofastq/output_fastq_o1
      reverse_fastq_list:
        default: []
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  decider_readgroup_o2:
    run: /tools/decider_readgroup_expression.cwl
    in:
      forward_fastq_list: biobambam_bamtofastq/output_fastq_o2
      reverse_fastq_list:
        default: []
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]
