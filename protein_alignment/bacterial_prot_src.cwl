#!/usr/bin/ent cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Get Proteins, bacterial_prot_src"


requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
      - entry: $(inputs.blastdb_dir)
        writable: False
      - entryname: blastdbs.mft
        entry: ${            var blob = '# blastdbs.mft created for bacterial_prot_src from input "blastdb" Array of blastdbs' +              '\n' ;             var i = 0;            for (i = 0; i < inputs.blastdb.length; i++) {               blob += inputs.blastdb_dir.path + '/' + inputs.blastdb[i] + String.fromCharCode(10);             }             for (i = 0; i < inputs.all_order_specific_blastdb.length; i++) {               blob += inputs.blastdb_dir.path + '/' + inputs.all_order_specific_blastdb[i] + String.fromCharCode(10);             }             return blob;           }        
        
baseCommand: bacterial_prot_src
arguments: [ -no-phage, -nogenbank ]

inputs:
  uniColl_asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  tax_sql_file:
    type: File
    inputBinding:
      prefix: -taxon-db
  naming_sqlite:
    type: File
    inputBinding:
      prefix: -unicoll_sqlite
  blastdb: # genomic
    type: string[]
  all_order_specific_blastdb: # 
    type: string[]
  blastdb_dir:
    type: Directory
    inputBinding:
      prefix: -blastdbs-manifest
      valueFrom: blastdbs.mft
    
  prot_output:
    type: string?
    default: all_prots.seqid
    inputBinding:
      prefix: -oall
  clust_output:
    type: string?
    default: universal_clusters.inf
    inputBinding:
      prefix: -ouniversal-clusters
  selected_blastdb_output:
    type: string?
    default: selected_blastdb.mft
    inputBinding:
      prefix: -selected-blastdb-manifest

outputs:
  universal_clusters:
    type: File
    outputBinding:
      glob: $(inputs.clust_output)
  all_prots:
    type: File
    outputBinding:
      glob: $(inputs.prot_output)
  selected_blastdb:
    type: File
    outputBinding:
      glob: $(inputs.selected_blastdb_output)
 
