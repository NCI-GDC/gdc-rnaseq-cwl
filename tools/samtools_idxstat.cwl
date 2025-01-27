cwlVersion: v1.0
class: CommandLineTool
id: samtools_idxstat
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/samtools:{{ samtools }}"
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam)
      - $(inputs.bam_index)
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.bam))
    outdirMin: $(file_size_multiplier(inputs.bam))

inputs:
  bam:
    type: File
    inputBinding:
      position: 0
      valueFrom: $(self.basename)

  bam_index:
    type: File

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot + ".idxstat")

stdout: $(inputs.bam.nameroot + ".idxstat")

baseCommand: [samtools, idxstats]
