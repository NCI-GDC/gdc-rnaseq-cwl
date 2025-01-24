cwlVersion: v1.0
class: CommandLineTool
id: fastq_vendor_fail_filter
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/gdc-vendorfail:1.1.0
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 4500
    tmpdirMin: |
      ${
         var f2 = inputs.input_r2 ? file_size_multiplier(inputs.input_r2) : 0;
         return file_size_multiplier(inputs.input_r1) + f2;
       }
    outdirMin: |
      ${
         var f2 = inputs.input_r2 ? file_size_multiplier(inputs.input_r2) : 0;
         return file_size_multiplier(inputs.input_r1) + f2;
       }
  - class: InitialWorkDirRequirement
    listing: |
      ${
        if (inputs.input_r2){ return [inputs.input_r1, inputs.input_r2] }
        else { return [inputs.input_r1] }
      }

inputs:
  input_r1:
    type: File
    inputBinding:
      position: 1

  input_r2:
    type: File?
    inputBinding:
      position: 2

  output_prefix:
    type: string
    inputBinding:
      position: 0
      prefix: -o

outputs:
  output_r1:
    type: File
    outputBinding:
      glob: $(inputs.output_prefix + '_R1.fq.gz')

  output_r2:
    type: File?
    outputBinding:
      glob: $(inputs.output_prefix + '_R2.fq.gz')
baseCommand: []
