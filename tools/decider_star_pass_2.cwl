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

  - id: fastq_s_paths
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
      // generate fastq paths
      var fastq_array = [];
      var readgroup_basename_array = [];

      function local_basename(path) {
        var basename = path.split(/[\\/]/).pop();
        return basename
      }

      function local_dirname(path) {
        return path.replace(/\\/g,'/').replace(/\/[^\/]*$/, '');
      }

      if (inputs.fastq1_paths.length > 0 and inputs.fastq1_paths.length == inputs.fastq2_paths.length) {
        for (var i = 0; i < inputs.fastq1_paths.length; i++) {
          fastq_array.push(inputs.fastq1_paths[i]);
          fastq_array.push(inputs.fastq2_paths[i]);

          var fastq1_name = local_basename(fastq1_paths[i]);
          var predicted_rg_name = fastq1_name.slice(0,-8) + ".json";
          readgroup_basename_array.push(predicted_rg_name);
        }
      }
      else {
        for (var i = 0; i < inputs.fastq_s_paths.length; i++) {
          fastq_array.push(inputs.fastq_s_paths[i]);

          var fastq_s_name = local_basename(fastq_s_paths[i]);
          var predicted_rg_name = fastq_s_name.slice(0,-8) + ".json";
          readgroup_basename_array.push(predicted_rg_name);
        }
      }

      // generate readgroup string
      var readgroup_str = "";
      readgroup_dirname = local_dirname(inputs.readgroup_paths[0].location)
      for (var i = 0; i < inputs.readgroup_basename_array.length; i++) {
        var this_readgroup_name = inputs.readgroup_basename_array[i];
        var this_readgroup_path = readgroup_dirname + this_readgroup_name;
        var readgroup_json = JSON.parse(this_readgroup_path.contents);
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
