cwlVersion: v1.0
class: CommandLineTool
id: extract_fastqs_from_tarball
requirements:
  - class: DockerRequirement
    dockerPull: docker.osdc.io/ncigdc/bio-tarball-to-fastqgz:0.2.0
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1024
    ramMax: 1024
    tmpdirMin: $(Math.ceil(inputs.file_size / 1048576))
    tmpdirMax: $(Math.ceil(inputs.file_size / 1048576))
    outdirMin: $(Math.ceil(inputs.file_size / 1048576))
    outdirMax: $(Math.ceil(inputs.file_size / 1048576))
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl

inputs:
  tarball:
    type: File
    inputBinding:
      prefix: --tarball
      position: 1
  sample_uuid:
    type: string
    inputBinding:
      prefix: --sample
      position: 2

outputs:
  readgroup_fastq_file_list:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file
    outputBinding:
      glob: "*.json"
      loadContents: true
      outputEval: |
        ${
          var res = JSON.parse(self[0].contents)
          var location = self[0].location.replace(self[0].basename, '')
          location = location.replace('file://', '')
          var re = /^\//i
          var expand_path = function(item){
            item.forward_fastq.location = location + item.forward_fastq.location.replace(re, '')
            if ('reverse_fastq' in item) {
              item.reverse_fastq.location = location + item.reverse_fastq.location.replace(re, '')
            }
            return item
          }
          var updated = res.map(expand_path)
          return updated
        }
