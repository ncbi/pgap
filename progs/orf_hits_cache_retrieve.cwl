#!/usr/bin/env cwl-runner
cwlVersion: v1.0
label: orf_hits_cache_retrieve
class: CommandLineTool
baseCommand: orf_hits_cache_retrieve
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
     - entry: $(inputs.proteins)
       writable: false
     - entryname: empty.cache
       entry: ${ return ''; }
       writable: true
     - entryname: ids.mft
       entry: |-
        ${
          var blob = '# ids.mft created for orf_hits_cache_retrieve from input "orfs" Array of Files' +
            String.fromCharCode(10) ; 
          for (var i = 0; i < inputs.orfs.length; i++) { 
            blob += inputs.orfs[i].path + String.fromCharCode(10); 
          } 
          return blob; 
        }

inputs:
  lds2: 
    type: File
    inputBinding:
      prefix: -lds2
  proteins: 
    type: File
  taxid: 
    type: int?
    inputBinding:
      prefix: -taxid
  blast_type:
    type: string?
    inputBinding:
      prefix: -blast-type
  genus_list: 
    type: int[]?
    inputBinding:
      prefix: -genus-list
      itemSeparator: ","
  orfs: 
    type: File[]
  orfs_manifest:
    type: string?
    default: ids.mft
    inputBinding:
      prefix: -orfs-manifest
  sqlite_cache: 
    type: File?
    # default: 
      # class: File
      # basename: 'empty.cache'
      # dirname: '.'
      # contents: ''
  sqlite_cache_opt:
    type: string? 
    default: 'this-should-be-replaced'
    inputBinding:
      valueFrom: ${ if (inputs.sqlite_cache != null) { return inputs.sqlite_cache.path; } else { return 'empty.cache'; }}
      prefix: -blast-hits-sqlite-cache 
  hits_output_name:
    type: string?
    default: retrieved_hits.asn
    inputBinding:
      prefix: -hits-output
  not_found_output_name:
    type: string?
    default: not_found.ids
    inputBinding:
      prefix: -not-found-output
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
    
outputs: 
  hits_output:
    type: File
    outputBinding:
      glob: $(inputs.hits_output_name)
  not_found_output:
    type: File
    outputBinding:
      glob: $(inputs.not_found_output_name)
