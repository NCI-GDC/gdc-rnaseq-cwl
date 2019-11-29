cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_input_bam_processing_wf
requirements:
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  readgroups_bam_file:
    type: ../../../tools/readgroup.cwl#readgroup_bam_file

outputs:
  pe_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: readgroup_fastq_pe/output
  se_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: readgroup_fastq_se/output
  o1_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: readgroup_fastq_o1/output
  o2_file_list:
    type:
      type: array
      items: ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: readgroup_fastq_o2/output

steps:
  biobambam_bamtofastq:
    run: ../../../tools/biobambam2_bamtofastq.cwl
    in:
      filename:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
    out: [ output_fastq1, output_fastq2, output_fastq_o1, 
           output_fastq_o2, output_fastq_s ]

  bam_readgroup_to_json:
    run: ../../../tools/bam_readgroup_to_json.cwl
    in:
      INPUT:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
      MODE:
        default: "lenient"
    out: [ OUTPUT, log ]

  decider_readgroup_pe:
    run: ../../../tools/decider_readgroup_expression.cwl
    in:
      fastq: biobambam_bamtofastq/output_fastq1
      readgroup_json: bam_readgroup_to_json/OUTPUT
    out: [ output ]

  decider_readgroup_se:
    run: ../../../tools/decider_readgroup_expression.cwl
    in:
      fastq: biobambam_bamtofastq/output_fastq_s
      readgroup_json: bam_readgroup_to_json/OUTPUT
    out: [ output ]

  decider_readgroup_o1:
    run: ../../../tools/decider_readgroup_expression.cwl
    in:
      fastq: biobambam_bamtofastq/output_fastq_o1
      readgroup_json: bam_readgroup_to_json/OUTPUT
    out: [ output ]

  decider_readgroup_o2:
    run: ../../../tools/decider_readgroup_expression.cwl
    in:
      fastq: biobambam_bamtofastq/output_fastq_o2
      readgroup_json: bam_readgroup_to_json/OUTPUT
    out: [ output ]

  readgroup_fastq_pe:
    run: ./make_readgroup_fastq.cwl
    scatter: [forward_fastq, reverse_fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      forward_fastq: biobambam_bamtofastq/output_fastq1
      reverse_fastq: biobambam_bamtofastq/output_fastq2
      readgroup_json: decider_readgroup_pe/output
    out: [ output ]

  readgroup_fastq_se:
    run: ./make_readgroup_fastq.cwl
    scatter: [forward_fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      forward_fastq: biobambam_bamtofastq/output_fastq_s
      readgroup_json: decider_readgroup_se/output
    out: [ output ]

  readgroup_fastq_o1:
    run: ./make_readgroup_fastq.cwl
    scatter: [forward_fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      forward_fastq: biobambam_bamtofastq/output_fastq_o1
      readgroup_json: decider_readgroup_o1/output
    out: [ output ]

  readgroup_fastq_o2:
    run: ./make_readgroup_fastq.cwl
    scatter: [forward_fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      forward_fastq: biobambam_bamtofastq/output_fastq_o2
      readgroup_json: decider_readgroup_o2/output
    out: [ output ]
