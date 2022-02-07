cwlVersion: v1.0
class: CommandLineTool
id: untar_archive
requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1 
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_tar, 1.8))
    outdirMin: $(file_size_multiplier(inputs.input_tar, 1.8))
doc: Untar archived directory 

inputs:
  input_tar:
    type: File
    doc: The tarfile to process
    inputBinding:
      position: 0
      prefix: -f

outputs:
  out_directory:
    type: Directory
    outputBinding:
      glob: |
        ${
          var idxarr = ['.tar.gz', '.tgz'].filter(
            function(end){
              return inputs.input_tar.basename.lastIndexOf(end) != -1
              })
          if(idxarr.length != 1) {
            throw("Unexpected name extension! Must be one of .tar.gz or .tgz")
          }
          var idx = inputs.input_tar.basename.lastIndexOf(idxarr[0])
          return inputs.input_tar.basename.slice(0, idx)
        } 

baseCommand: [/bin/tar, -xz]
