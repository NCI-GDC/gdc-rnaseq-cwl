- |
  function sum_file_array_size(farr) {
    var divisor = 1048576;
    var total = 0;
    for (var i = 0; i<farr.length; i++) {
      total += farr[i].size
    } 
    return Math.ceil(total / divisor);
  } 

- |
  function file_size_multiplier(fobj, mult) {
    mult = typeof mult !== 'undefined' ? mult : 1;
    var divisor = 1048576;
    return Math.ceil(mult * fobj.size / divisor);
  } 

- |
  function star_size_est(inputs) {
    var divisor = 1048576;
    var total = 0;
    for (var i = 0; i<inputs.readgroup_fastq_file_list.length; i++) {
      var curr = inputs.readgroup_fastq_file_list[i];
      total += curr.forward_fastq.size; 
      if(curr.reverse_fastq !== null) {
        total += curr.reverse_fastq.size;
      }
    } 
    var gsize = sum_file_array_size(inputs.genomeDir.listing)
    return Math.ceil((total / divisor) + gsize);
  } 
