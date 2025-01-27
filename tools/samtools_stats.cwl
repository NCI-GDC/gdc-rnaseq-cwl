cwlVersion: v1.0
class: CommandLineTool
id: samtools_stats
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/samtools:{{ samtools }}
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.bam)
      - $(inputs.bam_index)
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.bam))
    outdirMin: $(file_size_multiplier(inputs.bam))

inputs:
  bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

  bam_index:
    type: File

  threads:
    type: int?
    inputBinding:
      prefix: -@
      position: 0

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot + ".samtools_stats")

stdout: $(inputs.bam.nameroot + ".samtools_stats")

baseCommand: [samtools, stats]
