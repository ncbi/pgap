#!/usr/bin/env cwl-runner

cwlVersion: v1.2
label: asn_translator
class: CommandLineTool
baseCommand: asn_translator
inputs:            
  class1:
     type: string?
     inputBinding:
        prefix: -class
  conffile:
     type: File?
     inputBinding:
        prefix: -conffile
  input:
     type: File?
     inputBinding:
        prefix: -input
  input_manifest:
     type: File?
     inputBinding:
        prefix: -input-manifest
  input_mask:
     type: string?
     inputBinding:
        prefix: -input-mask
  input_path:
     type: string?
     inputBinding:
        prefix: -input-path
  items_per_chunk:
     type: int?
     inputBinding:
        prefix: -items-per-chunk
  len:
     type: int?
     inputBinding:
        prefix: -len
  max_chunk_size:
     type: long?
     inputBinding:
        prefix: -max-chunk-size
  max_files_per_dir:
     type: int?
     inputBinding:
        prefix: -max-files-per-dir
  max_objects:
     type: int?
     inputBinding:
        prefix: -max-objects
  min_chunk_size:
     type: int?
     inputBinding:
        prefix: -min-chunk-size
  
  num_partitions:
     type: int?
     inputBinding:
        prefix: -num-partitions
  
  offset:
     type: long?
     inputBinding:
        prefix: -offset
  
  logfile_output:
     type: string?
     inputBinding:
        prefix: -logfile
  
  output_output:
     type: string?
     inputBinding:
        prefix: -output
  
  output_manifest_output:
     type: string?
     inputBinding:
        prefix: -output-manifest
        
outputs:
       
  logfile:
      type: File?
      outputBinding:
          glob: $(inputs.logfile_output)
  
  output:
      type: File?
      outputBinding:
          glob: $(inputs.output_output)
  
  output_manifest:
      type: File?
      outputBinding:
          glob: $(inputs.output_manifest_output)
