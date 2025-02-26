cwlVersion: v1.0
class: CommandLineTool
id: samtools_flagstat
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/samtools:{{ samtools }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
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

  threads:
    type: int?
    inputBinding:
      prefix: -@
      position: 0

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam.nameroot + ".flagstat")

stdout: $(inputs.bam.nameroot + ".flagstat")

baseCommand: [samtools, flagstat]
