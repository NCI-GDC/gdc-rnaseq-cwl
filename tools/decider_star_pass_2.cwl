#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: fastq1_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: fastq2_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: readgroup_paths
    type:
      type: array
      items: File
      inputBinding:
        loadContents: true
        valueFrom: null

outputs:
  - id: output_fastq_paths
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: output_readgroup_str
    type: string

expression: |
   ${
      if (inputs.fastq1_paths.length != inputs.fastq2_paths.length) {
       return null;
      }

      // generate fastq paths
      var fastq_array = [];
      for (var i = 0; i < inputs.fastq1_paths.length; i++) {
        fastq_array.push(inputs.fastq1_paths[i]);
        fastq_array.push(inputs.fastq2_paths[i]);
      }

      // generate readgroup string
      var readgroup_str = "";
      for (var i = 0; i < inputs.readgroup_paths.length; i++) {
        var readgroup_json = JSON.parse(inputs.readgroup_paths[i].contents);
        var this_readgroup = "";
        this_readgroup = "ID:" + readgroup_json["ID"] + " ";
        var keys = Object.keys(readgroup_json).sort();
        for (var j = 0; j < keys.length; j++) {
          var key = keys[j];
          var value = readgroup_json[key];
          if (key != "ID") {
            this_readgroup = this_readgroup + key + ":" + value + " ";
          }
        }
        this_readgroup = this_readgroup.substring(0, this_readgroup.length-1);
        readgroup_str = readgroup_str + this_readgroup + " , ";
      }
      readgroup_str = readgroup_str.substring(0, readgroup_str.length-3);

      return {'output_fastq_paths': fastq_array, "output_readgroup_str": readgroup_str};
    }
