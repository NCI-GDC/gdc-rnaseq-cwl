#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:c5581c5429a9920db12a94381d8c22a7f1436dc1b0e2ec3d56317642250038ac
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

inputs:
  config-file:
    type: File?

  upload-bucket:
    type: string?

  upload-key:
    type: string?

  input:
    type: File?

outputs:
  uuid:
    type: string?
    outputBinding:
      glob: "*_upload.json"      
      loadContents: true
      outputEval: |
        ${
           if(self.length > 0) {
               var data = JSON.parse(self[0].contents);
               return(data["did"]);
           } else {
               return null
           }
         }

baseCommand: []

arguments:
  - valueFrom: |
      ${
         var tool = "/usr/local/bin/bio_client.py"
         var reqs = ["config-file", "upload-bucket", "upload-key"]
         var cmd = []

         if(inputs.input !== null) {
             for(var i=0; i < reqs.length; i++) {
                 if(inputs[i] === null) {
                     throw "Missing required option " + i
                 }
             }
             cmd.push(tool)
             cmd.push("--config-file")
             cmd.push(inputs['config-file'].path)
             cmd.push("upload")
             cmd.push("--upload-bucket")
             cmd.push(inputs['upload-bucket'])
             cmd.push("--upload_key")
             cmd.push(inputs['upload-key'])
             cmd.push(inputs.input)
         } else {
             cmd.push("true")
         }
         return cmd
       }
