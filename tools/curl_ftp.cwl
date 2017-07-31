#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:latest
  - class: InlineJavascriptRequirement

inputs:
  - id: url
    type: string
    inputBinding:
      position: 0

outputs:
  - id: output
    type: File
    outputBinding:
      glob: |
        ${
          function local_basename(path) {
            var basename = path.split(/[\\/]/).pop();
            return basename
          }

          var ftp_basename = local_basename(inputs.url);
          return ftp_basename
        }

stdout: |
  ${
          function local_basename(path) {
            var basename = path.split(/[\\/]/).pop();
            return basename
          }

          var ftp_basename = local_basename(inputs.url);
          return ftp_basename
  }
    
baseCommand: [curl]
