cwlVersion: v1.0
class: CommandLineTool
id: fastqc
requirements:
  - class: DockerRequirement
    dockerPull: {{ docker_repository }}/fastqc:a285d4ab748fa11e6029ad1019ea645ed2b1657e5d49c850a322fdf4b402c1b9
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: "$(inputs.threads ? inputs.threads : 1)"
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.INPUT))
    outdirMin: $(sum_file_array_size(inputs.INPUT))

inputs:
  adapters:
    type: File?
    inputBinding:
      prefix: --adapters

  casava:
    type: boolean?
    inputBinding:
      prefix: --casava

  contaminants:
    type: File?
    inputBinding:
      prefix: --contaminants

  dir:
    type: string
    default: .
    inputBinding:
      prefix: --dir

  extract:
    type: boolean?
    inputBinding:
      prefix: --extract

  format:
    type: string
    default: fastq
    inputBinding:
      prefix: --format

  INPUT:
    type: File[]
    inputBinding:
      position: 99

  kmers:
    type: int?
    inputBinding:
      prefix: --kmers

  limits:
    type: File?
    inputBinding:
      prefix: --limits

  nano:
    type: boolean?
    inputBinding:
      prefix: --nano

  noextract:
    type: boolean
    default: true
    inputBinding:
      prefix: --noextract

  nofilter:
    type: boolean?
    inputBinding:
      prefix: --nofilter

  nogroup:
    type: boolean?
    inputBinding:
      prefix: --nogroup

  outdir:
    type: string
    default: .
    inputBinding:
      prefix: --outdir

  quiet:
    type: boolean?
    inputBinding:
      prefix: --quiet

  threads:
    type: int?
    inputBinding:
      prefix: --threads

outputs:
  OUTPUT:
    type: File[]
    outputBinding:
      glob: $('*_fastqc.zip')

baseCommand: [/usr/local/FastQC/fastqc]
