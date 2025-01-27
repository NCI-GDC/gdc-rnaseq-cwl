cwlVersion: v1.0
class: CommandLineTool
id: archive_directory
requirements:
  - class: DockerRequirement
    dockerPull: alpine:{{ alpine }} 
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000 
    ramMax: 1000 
doc: |
    Creates a tar.gz archive of a directory

inputs:
  input_directory:
    type: Directory
    doc: Path to directory you want to archive
    inputBinding:
      position: 2
      valueFrom: $(self.basename)

outputs:
  output_archive:
    type: File
    outputBinding:
      glob: $(inputs.input_directory.basename + '.tar.gz')
    doc: The archived directory

baseCommand: [tar]

arguments:
  - valueFrom: $(inputs.input_directory.dirname)
    position: 0
    prefix: -C
  - valueFrom: $(inputs.input_directory.basename + '.tar.gz')
    position: 1
    prefix: -hczf
