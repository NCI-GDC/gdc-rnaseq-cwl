cwlVersion: v1.0
class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/star_results.cwl

inputs:
  ref_flat: File
  ribosome_intervals: File?
  fastqc_files: File[]
  genome_bam: File
  threads: int?
  picard_mem: int
  star_results:
    type: 
      type: array
      items: ../../tools/star_results.cwl#star_results
  job_uuid: string

outputs:
  metrics_db:
    type: File 
    outputSource: picard_db/db

steps:
  get_readgroup_json:
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      INPUT: genome_bam
      MODE:
        default: "lenient"
    out: [ OUTPUT, log ]

  initialize_db:
    run: ../../tools/gdc_qc_tool.readgroups.cwl
    in:
      input: get_readgroup_json/OUTPUT
      job_uuid: job_uuid
      bam: genome_bam
    out: [ db ]

  fastqc_db:
    run: ../../tools/gdc_qc_tool.fastqc.cwl
    in:
      input: fastqc_files 
      job_uuid: job_uuid
      input_db: initialize_db/db
    out: [ db ]

  star_db:
    run: ../../tools/gdc_qc_tool.star.cwl
    in:
      job_uuid: job_uuid
      input_db: fastqc_db/db
      input_log:
        source: star_results
        valueFrom: |
          ${
             var in_sorted = self.sort(function(a,b) { 
                 return a.star_stats.location > b.star_stats.location ? 1 : (a.star_stats.location < b.star_stats.location ? -1 : 0) 
             });

             var res = []
             for( var i = 0; i < in_sorted.length; i++ ) {
                 res.push(in_sorted[i].star_stats)
             }
             return res;
           }

      input_counts:
        source: star_results 
        valueFrom: |
          ${
             var in_sorted = self.sort(function(a,b) { 
                 return a.star_stats.location > b.star_stats.location ? 1 : (a.star_stats.location < b.star_stats.location ? -1 : 0) 
             });
             var res = []
             for( var i = 0; i < in_sorted.length; i++ ) {
                 res.push(in_sorted[i].star_gene_counts)
             }
             return res;
           }

      bam:
        source: star_results 
        valueFrom: |
          ${
             var in_sorted = self.sort(function(a,b) { 
                 return a.star_stats.location > b.star_stats.location ? 1 : (a.star_stats.location < b.star_stats.location ? -1 : 0) 
             });
             var res = []
             for( var i = 0; i < in_sorted.length; i++ ) {
                 res.push(in_sorted[i].star_genome_bam)
             }
             return res;
           }
    out: [ db ]

  samtools_flagstats:
    run: ../../tools/samtools_flagstat.cwl
    in:
      bam: genome_bam
      threads: threads
    out: [ output ]

  flagstat_db:
    run: ../../tools/gdc_qc_tool.samtools_flagstat.cwl
    in:
      input:
        source: samtools_flagstats/output 
        valueFrom: $([self])
      job_uuid: job_uuid
      input_db: star_db/db 
      bam: genome_bam
    out: [ db ]

  samtools_idxstats:
    run: ../../tools/samtools_idxstat.cwl
    in:
      bam: genome_bam
      bam_index:
        source: genome_bam
        valueFrom: $(self.secondaryFiles[0])
    out: [ output ]

  idxstat_db:
    run: ../../tools/gdc_qc_tool.samtools_idxstat.cwl
    in:
      input:
        source: samtools_idxstats/output 
        valueFrom: $([self])
      job_uuid: job_uuid
      input_db: flagstat_db/db 
      bam: genome_bam
    out: [ db ]

  samtools_stats:
    run: ../../tools/samtools_stats.cwl
    in:
      bam: genome_bam
      bam_index:
        source: genome_bam
        valueFrom: $(self.secondaryFiles[0])
    out: [ output ]

  samtools_stats_db:
    run: ../../tools/gdc_qc_tool.samtools_stats.cwl
    in:
      input: samtools_stats/output
      job_uuid: job_uuid
      input_db: idxstat_db/db 
      bam: genome_bam
    out: [ db ]

  picard_rnaseq_metrics:
    run: ../../tools/picard_collectrnaseqmetrics.cwl
    in:
      java_mem: picard_mem
      INPUT: genome_bam
      REF_FLAT: ref_flat 
      RIBOSOMAL_INTERVALS: ribosome_intervals
      METRIC_ACCUMULATION_LEVEL: 
        default: ["ALL_READS", "READ_GROUP"]
    out: [ OUTPUT, CHART_OUTPUT ]

  picard_db:
    run: ../../tools/gdc_qc_tool.picard.cwl
    in:
      input: 
        source: picard_rnaseq_metrics/OUTPUT
        valueFrom: $([self])
      job_uuid: job_uuid
      input_db: samtools_stats_db/db 
      bam: genome_bam
    out: [ db ]
