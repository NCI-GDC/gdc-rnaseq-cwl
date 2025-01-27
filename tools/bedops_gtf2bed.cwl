cwlVersion: v1.0
class: CommandLineTool
id: bedops_gtf2bed
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/bedops:{{ bedops }}"
  - class: InlineJavascriptRequirement

inputs:
  INPUT:
    type: File
    format: "edam:format_2306"

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot).bed

stdin: $(inputs.INPUT.path)

stdout: $(inputs.INPUT.nameroot).bed

baseCommand: [/usr/local/bin/gtf2bed]
