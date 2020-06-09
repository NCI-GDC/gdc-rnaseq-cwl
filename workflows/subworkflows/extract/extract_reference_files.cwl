cwlVersion: v1.0
class: Workflow
id: gdc_rnaseq_extract_reference_files_wf

inputs:
  ribosome_intervals_uuid: string
  ref_flat_uuid: string
  star_index_archive_uuid: string
  bioclient_config: File

outputs:
  ribosome_intervals:
    type: File
    outputSource: extract_ribosome/output

  ref_flat: 
    type: File
    outputSource: extract_ref_flat/output

  star_genome_dir: 
    type: Directory 
    outputSource: untar_star_index/out_directory

steps:
  extract_ribosome:
    run: ../../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: ribosome_intervals_uuid
    out: [ output ]

  extract_ref_flat:
    run: ../../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: ref_flat_uuid
    out: [ output ]

  extract_star_index:
    run: ../../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: star_index_archive_uuid
    out: [ output ]

  untar_star_index:
    run: ../../../tools/untar_archive.cwl
    in:
      input_tar: extract_star_index/output
    out: [ out_directory ]
