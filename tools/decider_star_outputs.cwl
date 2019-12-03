cwlVersion: v1.0
class: ExpressionTool
id: decider_star_outputs 
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ./star_results.cwl

inputs:
  star_results:
    type:
      type: array
      items: ./star_results.cwl#star_results

outputs:
  output_transcriptome_bam: File? 
  output_chimeric_bam: File? 
  output_chimeric_junctions: File? 

expression: |
  ${
     function extract_file_from_array( arr ) {
       if( arr.length == 0 ) {
         return null; 
       } else if (arr.length == 1) {
         return arr[0];
       } else {
         throw "Multiple inputs not allowed!"
       }
     }

     var tbam = [];
     var cbam = [];
     var ctsv = [];

     for(var i=0; i<self.inputs.star_results.length; i++) {
       if(self[i].is_paired) {
         tbam.push(self.inputs.star_results[i].star_transcriptome_bam);
         cbam.push(self.inputs.star_results[i].star_chimeric_bam);
         ctsv.push(self.inputs.star_results[i].star_chimeric_junctions);
       }
     }

     var out = {
       "output_transcriptome_bam": extract_file_from_array(tbam),
       "output_chimeric_bam": extract_file_from_array(cbam),
       "output_chimeric_juncstions": extract_file_from_array(ctsv)
     }
     return out;
   }
