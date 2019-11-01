cwlVersion: v1.0 
label: "gpx_qsubmit"
doc: >
    This workflow is specialized for the case when there is an XML input 

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry:  ${ var cs=0; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False
      - entry:  ${ var cs=1; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False

baseCommand: gpx_qsubmit
inputs:
  affinity:
    type: string?
    default: subject
    inputBinding:
      prefix: -affinity
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  batch_size:
    type: int?
    inputBinding:
      prefix: -batch-size
  max_batch_length:
    type: int?
    inputBinding:
      prefix: -max-batch-length
  nogenbank:
    type: boolean?
    inputBinding:
      # prefix: -nogenbank # commenting this as a hail mary
  NxM_threshold:
    type: int?
    inputBinding:
      prefix: -NxM-threshold
  overlap:
    type: int?
    inputBinding:
      prefix: -overlap
  subseq_size:
    type: int?
    inputBinding:
      prefix: -subseq-size
  xml_jobs:
    type: File?
    inputBinding:
      prefix: -xml-jobs
  output_xml_jobs:
    type: string
    default: jobs.xml
    inputBinding:
      prefix: -o
  
      
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output_xml_jobs)    
