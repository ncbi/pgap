#!/usr/bin/env cwl-runner

cwlVersion: v1.0
label: asn_translator
class: CommandLineTool
baseCommand: asn_translator
inputs:            
  class:
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
  input-manifest:
     type: File?
     inputBinding:
        prefix: -input-manifest
  input-mask:
     type: string?
     inputBinding:
        prefix: -input-mask
  input-path:
     type: string?
     inputBinding:
        prefix: -input-path
  items-per-chunk:
     type: int?
     inputBinding:
        prefix: -items-per-chunk
  len:
     type: int?
     inputBinding:
        prefix: -len
  max-chunk-size:
     type: long?
     inputBinding:
        prefix: -max-chunk-size
  max-files-per-dir:
     type: int?
     inputBinding:
        prefix: -max-files-per-dir
  max-objects:
     type: int?
     inputBinding:
        prefix: -max-objects
  min-chunk-size:
     type: int?
     inputBinding:
        prefix: -min-chunk-size
  
  num-partitions:
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
  
  output-manifest_output:
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
  
  output-manifest:
      type: File?
      outputBinding:
          glob: $(inputs.output-manifest_output)
