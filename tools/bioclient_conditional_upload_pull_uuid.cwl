cwlVersion: v1.0
class: CommandLineTool
id: bioclient_conditional_upload_pull_uuid
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: "{{ docker_repository }}/bio-client:{{ bio-client }}"
  - class: InitialWorkDirRequirement
    listing: |
      ${
         if ( inputs.input !== null ) {
           return [{"entry": inputs.input, "entryname": inputs.filename}]
         } else {
           return []
         }
       }
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    outdirMin: 1
  - class: EnvVarRequirement
    envDef:
    - envName: "REQUESTS_CA_BUNDLE"
      envValue: $(inputs.cert.path)

inputs:
  cert:
    type: File
    default:
      class: File
      location: /etc/ssl/certs/ca-certificates.crt

  config-file:
    type: File?

  upload-bucket:
    type: string?

  upload-key:
    type: string?

  input:
    type: File?

  filename:
    type: string

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
             cmd.push(inputs.filename)
         } else {
             cmd.push("true")
         }
         return cmd
       }
