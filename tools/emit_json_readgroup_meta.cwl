cwlVersion: v1.0
class: ExpressionTool
id: emit_json_readgroup_meta
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.cwl

inputs:
  input:
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

outputs:
  output:
    type: readgroup.cwl#readgroup_meta

expression: |
  ${
    var readgroup = JSON.parse(inputs.input.contents);
    var output = new Object();
    for (var i in readgroup) {
      if (i.length == 2) {
        if (i == 'PL') {
          output[i] = readgroup[i].toUpperCase();
        } else {
          output[i] = readgroup[i];
        }
      }
    }

    return {'output': output};
  }
