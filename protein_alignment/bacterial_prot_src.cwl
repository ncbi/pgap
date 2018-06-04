#!/usr/bin/ent cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Get Proteins, bacterial_prot_src"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
      - entry: $(inputs.uniColl_path)
        writable: False

baseCommand: bacterial_prot_src
arguments: [ -no-phage, -nogenbank ]

inputs:
  uniColl_asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  taxid:
    type: string
    inputBinding:
      prefix: -taxid
  tax_sql_file:
    type: File
    inputBinding:
      prefix: -taxon-db
  uniColl_path:
    type: Directory
    inputBinding:
      prefix: -unicoll_path
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

outputs:
  universal_clusters:
    type: File
    outputBinding:
      glob: $(inputs.clust_output)
  all_prots:
    type: File
    outputBinding:
      glob: $(inputs.prot_output)
 
