cwlVersion: v1.0
class: CommandLineTool
id: bioclient_conditional_download
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil (inputs.file_size / 1048576))
    tmpdirMax: $(Math.ceil (inputs.file_size / 1048576))
    outdirMin: $(Math.ceil (inputs.file_size / 1048576))
    outdirMax: $(Math.ceil (inputs.file_size / 1048576))

inputs:
  config-file:
    type: File?

  dir_path:
    type: string?
    default: "."

  download_handle:
    type: string?

  file_size:
    type: long?
    default: 1

outputs:
  output:
    type: File?
    outputBinding:
      glob: "*"

baseCommand: []

arguments:
  - valueFrom: |
      ${
         var tool = "/usr/local/bin/bio_client.py"
         var reqs = ["config-file", "dir_path"]
         var cmd = []

         if(inputs.download_handle !== null) {
             for(var i=0; i < reqs.length; i++) {
                 if(inputs[i] === null) {
                     throw "Missing required option " + i
                 }
             }
             cmd.push(tool)
             cmd.push("--config-file")
             cmd.push(inputs['config-file'].path)
             cmd.push("download")
             cmd.push(inputs['download_handle'])
             cmd.push("--dir_path")
             cmd.push(inputs['dir_path'])
         } else {
             cmd.push("true")
         }
         return cmd
       }
