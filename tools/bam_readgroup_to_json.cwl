cwlVersion: v1.0
class: CommandLineTool
id: bam_readgroup_to_json
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_readgroup_to_json:75fdf4511a17a035aeeb67fcce26a815b6b824e56ee033c6bbd2d2d99dd8c558 
  - class: InlineJavascriptRequirement
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
  INPUT:
    type: File
    inputBinding:
      prefix: --bam_path

  MODE:
    type: string
    default: strict
    inputBinding:
      prefix: --mode

outputs:
  OUTPUT:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.json"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  log:
    type: File
    outputBinding:
      glob: "output.log"

baseCommand: [/usr/local/bin/bam_readgroup_to_json]
