cwlVersion: v1.0
class: CommandLineTool
id: rename_file
requirements:
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: DockerRequirement
    dockerPull: "alpine:{{ alpine }}"
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_file))
    outdirMin: $(file_size_multiplier(inputs.input_file))
  - class: InitialWorkDirRequirement
    listing: |
      ${
        var ret_list = [
          {"entry": inputs.input_file, "writable": false, "entryname": inputs.output_filename},
        ];
        return ret_list
      }
doc: |
    Renames the file

inputs:
  input_file:
    type: File
    doc: The file to rename

  output_filename:
    type: string
    doc: the updated name of the output file

outputs:
  out_file:
    type: File
    outputBinding:
      glob: $(inputs.output_filename)

baseCommand: 'true'
