cwlVersion: v1.0
class: ExpressionTool
id: decider_readgroup_expression
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl

inputs:
  forward_fastq_list: File[]
  reverse_fastq_list: File[]
  bam_readgroup_contents: string[]
  readgroup_meta_list:
    type:
      type: array
      items: readgroup.cwl#readgroup_meta

outputs:
  output:
    type:
      type: array
      items: readgroup.cwl#readgroup_fastq_file

expression: |
  ${
     function endsWith(str, suffix) {
       return str.indexOf(suffix, str.length - suffix.length) !== -1;
     }

     function local_basename(path) {
       var basename = path.split(/[\\/]/).pop();
       return basename
     }

     function get_slice_number(fastq_name) {
       if (endsWith(fastq_name, '_1.fq.gz')) {
         return -8
       }
       else if (endsWith(fastq_name, '_s.fq.gz')) {
         return -8
       }
       else if (endsWith(fastq_name, '_o1.fq.gz')) {
         return -9
       }
       else if (endsWith(fastq_name, '_o2.fq.gz')) {
         return -9
       }
       else {
         throw "not recognized fastq suffix"
       }
     }
     
     // get readgroup name from fastq
     function fastq_to_rg_id(fq_file_object) {
       var fastq_name = local_basename(fq_file_object.location);
       var slice_number = get_slice_number(fastq_name);
       var readgroup_name = fastq_name.slice(0,slice_number);
       return readgroup_name;
     }

     function load_bamrgs() {
       var res = [];
       for (var i = 0; i < inputs.bam_readgroup_contents.length; i++) {
         var curr = JSON.parse(inputs.bam_readgroup_contents[i]);
         res.push(curr);
       }
       return(res);
     }

     function find_graph_rg(bam_rgid) {
       for (var i = 0; i < inputs.readgroup_meta_list.length; i++) {
         var record = inputs.readgroup_meta_list[i];
         if (record["ID"] === bam_rgid) {
           return(record);
         }
       }
       return(null);
     }

     function find_bam_rg(bam_meta, rgid) {
       for (var i = 0; i < bam_meta.length; i++) {
         var record = bam_meta[i];
         if (record["ID"] === rgid) {
           return(record);
         }
       }
       return(null);
     }

     function make_record(readgroup_meta, forward_fastq, reverse_fastq) {
       var output = {"forward_fastq": forward_fastq,
                     "reverse_fastq": reverse_fastq,
                     "readgroup_meta": readgroup_meta};
       return(output);
     }

     function normalize_record(record) {
       // first meta_rg has right sample
       var first_rg = inputs.readgroup_meta_list[0];
       var first_sm = first_rg['SM'];
       var first_pl = first_rg['PL'].toUpperCase();

       if(!record.readgroup_meta.hasOwnProperty('SM') || record.readgroup_meta['SM'] !== first_sm) {
         record.readgroup_meta['SM'] = first_sm; 
       }

       if(!record.readgroup_meta.hasOwnProperty('LB') || record.readgroup_meta['LB'] === null) {
         record.readgroup_meta['LB'] = first_sm; 
       }

       if(!record.readgroup_meta.hasOwnProperty('PL') || record.readgroup_meta['PL'] === null) {
         record.readgroup_meta['PL'] = first_pl; 
       } else {
         record.readgroup_meta['PL'] = record.readgroup_meta['PL'].toUpperCase();
       }
     }

     // output
     var output_array = [];

     // bam rgs
     var bam_meta = load_bamrgs();

     // get readgroup names from fastq, lookup in graph, lookup in bam meta
     // if needed.
     for (var i = 0; i < inputs.forward_fastq_list.length; i++) {
       var fq = inputs.forward_fastq_list[i];
       var rev_fq = inputs.reverse_fastq_list.length > 0 ? inputs.reverse_fastq_list[i] : null;
       var readgroup_name = fastq_to_rg_id(fq);

       // try to look up in the graph metadata using rgname
       var graph_rg = find_graph_rg(readgroup_name);
       if (graph_rg !== null) {
         var rec = make_record(graph_rg, fq, rev_fq);
         normalize_record(rec);
         output_array.push(rec);
       }
       else {
         // Match with bam meta
         var bam_rg = find_bam_rg(bam_meta, readgroup_name);
         if(bam_rg === null) {
           throw "Unable to find the matching bam RG record";
         }
         var rec = make_record(bam_rg, fq, rev_fq);
         normalize_record(rec);
         output_array.push(rec);
       }
     }

     return {'output': output_array};
   }
