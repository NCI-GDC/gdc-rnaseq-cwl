cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_extract_readgroup_tarball_wf
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: ../../../tools/readgroup.cwl
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  sample_tarball_uuid:
    type: ../../../tools/readgroup.cwl#sample_tarball_uuid
  bioclient_config: File

outputs:
  output:
    type:
      type: array
      items:  ../../../tools/readgroup.cwl#readgroup_fastq_file
    outputSource: extract_tarball_readgroup_fastqs/readgroup_fastq_file_list

steps:
  download_tarball:
    run: ../../../tools/bioclient_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: sample_tarball_uuid
        valueFrom: $(self.tarball_uuid)
      file_size:
        source: sample_tarball_uuid
        valueFrom: $(self.tarball_file_size)
    out:
      [ output ]

  extract_tarball_readgroup_fastqs:
    run: ../../../tools/extract_fastqs_from_tarball.cwl
    in:
      tarball: download_tarball/output
      sample_uuid:
        source: sample_tarball_uuid
        valueFrom: $(self.sample_uuid)
    out:
      - readgroup_fastq_file_list
