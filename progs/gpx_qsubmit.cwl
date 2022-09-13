cwlVersion: v1.2
label: "gpx_qsubmit"
doc: >
    This workflow is specialized for the case when there is an LDS2 input 
    LDS2 is a _reference_ object, the kind that CWL does not like
    we need to provide actual input: proteins which matches the name of ASN.1 object
    references in LDS2
    Another limitation is that it can handle no more than two item arrays in blastdb_dir and asn_cache
    Workaround used so far:
    in:
      proteins:
        default:
            class: File
            path: '/dev/null'
            basename: 'null'
            contents: ''

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry:  $(inputs.proteins)
        writable: False
      - entry:  $(inputs.blastdb_dir)
        writable: False
      - entry:  |-
            ${ 
              if(inputs.asn_cache != null) {
                var cs=0; 
                var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; 
                return inputs.asn_cache[as]; 
              }
              else {
                return null;
              }
            }
        writable: False
      - entry:  |-
            ${ 
              if(inputs.asn_cache != null) {
                var cs=1; 
                var s=inputs.asn_cache.length-1; var as = cs; if(as >= s) {as = s }; 
                return inputs.asn_cache[as]; 
              }
              else {
                return null;
              }
            }
        writable: False
      - entryname: ids.mft
        entry:  |-
          ${
            var blob = '# ids.mft created for gpx_qsubmit from input ids Array of Files\n';
            if ( inputs.ids != null) {
              for (var i = 0; i < inputs.ids.length; i++) {
                blob += inputs.ids[i].path  + '\n';
              }
            }
            return blob;
          }

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
    type: string[]?
    # this part for testing only, it is not compatible with -db-manifest setting below
    inputBinding:
      prefix: -db
      valueFrom: |-
        ${ 
          var blob = ''; 
          if(inputs.blastdb != null) {
            for (var i = 0; i < inputs.blastdb.length; i++) { 
              blob += inputs.blastdb_dir.path + '/' + inputs.blastdb[i]; 
              if(i != inputs.blastdb.length-1) blob += ','; 
            } 
          }
          return blob; 
        }
  blastdb_dir:
    type: Directory?
  # this won't work because we create manifest in requirement: section simultaneously with declaring input directories "stable"
  # and "stability" is not achieved until we are done with requirements part (I guess)
  # blastdb_manifest:
  #   type: string?
  #   inputBinding:
  #     prefix: -db-manifest
  #     valueFrom: blastdb.mft
  # same here:
  ids:
    type: File[]?
  ids_manifest:
    type: string?
    default: ids.mft
    inputBinding: 
        prefix: -ids-manifest
  queries_gc_id_list:
    type: File?
    inputBinding:
        prefix: -queries-gc-id-list
  subjects_gc_id_list:
    type: File?
    inputBinding:
        prefix: -subjects-gc-id-list
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
    default: true
    inputBinding:
      prefix: -nogenbank
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
