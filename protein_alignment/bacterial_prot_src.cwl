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
      - entry: $(inputs.asn_cache)
        writable: False
      - entry: $(inputs.uniColl_asn_cache)
        writable: False
      - entry: $(inputs.uniColl_path)
        writable: False

baseCommand: bacterial_prot_src
arguments: [ -no-phage, -nogenbank ]

inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.uniColl_asn_cache.basename)
  uniColl_asn_cache:
    type: Directory
  clade:
    type: File
    inputBinding:
      prefix: -clade
  taxid:
    type: string
    inputBinding:
      prefix: -taxid
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
      prefix: -ouniversal_clusters

outputs:
  universal_clusters:
    type: File
    outputBinding:
      glob: $(inputs.clust_output)
  all_prots:
    type: File
    outputBinding:
      glob: $(inputs.prot_output)
 
