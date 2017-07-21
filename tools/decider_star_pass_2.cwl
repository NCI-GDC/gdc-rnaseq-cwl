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

      function include(arr,obj) {
        return (arr.indexOf(obj) != -1)
      }

      if (inputs.fastq1_paths.length > 0 && inputs.fastq1_paths.length == inputs.fastq2_paths.length) {
        for (var i = 0; i < inputs.fastq1_paths.length; i++) {
          fastq_array.push(inputs.fastq1_paths[i]);
          fastq_array.push(inputs.fastq2_paths[i]);

          var fastq1_name = local_basename(inputs.fastq1_paths[i].location);
          var predicted_rg_name = fastq1_name.slice(0,-8) + ".json";
          readgroup_basename_array.push(predicted_rg_name);
        }
      }
      else {
        for (var i = 0; i < inputs.fastq_s_paths.length; i++) {
          fastq_array.push(inputs.fastq_s_paths[i]);

          var fastq_s_name = local_basename(inputs.fastq_s_paths[i].location);
          var predicted_rg_name = fastq_s_name.slice(0,-8) + ".json";
          readgroup_basename_array.push(predicted_rg_name);
        }
      }

      // get needed readgroup objects
      var use_readgroup_array = [];
      for (var i = 0; i < inputs.readgroup_paths.length; i++) {
        var this_readgroup_object = inputs.readgroup_paths[i];
        var this_readgroup_basename = local_basename(this_readgroup_object.location);
        if (include(readgroup_basename_array, this_readgroup_basename)) {
          use_readgroup_array.push(this_readgroup_object)
        }
      }

      // generate readgroup string
      var readgroup_str = "";
      for (var i = 0; i < use_readgroup_array.length; i++) {
        var readgroup_json = JSON.parse(use_readgroup_array[i].contents);
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
