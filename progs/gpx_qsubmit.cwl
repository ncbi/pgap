cwlVersion: v1.0 
label: "gpx_qsubmit"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry:  $(inputs.proteins)
        writable: False
      - entry:  ${ var cs=0; var s=inputs.blastdb_dir.length-1; var as = cs; if(as >= s) {as = s }; return inputs.blastdb_dir[as]; }
        writable: False
      - entry:  ${ var cs=1; var s=inputs.blastdb_dir.length-1; var as = cs; if(as >= s) {as = s }; return inputs.blastdb_dir[as]; }
        writable: False
      - entry:  ${ var cs=0; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False
      - entry:  ${ var cs=1; var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; return inputs.asn_cache[as]; }
        writable: False
      - entryname: ids.mft
        entry:  ${var blob = '';for (var i = 0; i < inputs.ids.length; i++) {blob += inputs.ids[i].path  + '\n';}return blob;}

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
  blastdb:
    type: string?
    # this part for testing only, it is not compatible with -db-manifest setting below
    inputBinding:
      prefix: -db
      valueFrom: ${ var blob = ''; for (var i = 0; i < inputs.blastdb_dir.length; i++) { blob += inputs.blastdb_dir[i].path + '/' + inputs.blastdb; if(i != inputs.blastdb_dir.length-1) blob += ','; } return blob; }
  blastdb_dir:
    type: Directory[]
  # this won't work because we create manifest in requirement: section simultaneously with declaring input directories "stable"
  # and "stability" is not achieved until we are done with requirements part (I guess)
  # blastdb_manifest:
  #   type: string?
  #   inputBinding:
  #     prefix: -db-manifest
  #     valueFrom: blastdb.mft
  # same here:
  ids:
    type: File[]
  ids_manifest:
    type: string?
    default: ids.mft
    inputBinding: 
        prefix: -ids-manifest
  lds2:
    type: File?
    inputBinding:
      prefix: -lds2
  proteins: # companion to lds2
    type: File?
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
    type: string
    default: jobs.xml
    inputBinding:
      prefix: -o
      
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.xml_jobs)    
