#!/usr/bin/env cwl-runner
label: bacterial_orthology_cond
cwlVersion: v1.2
class: Workflow    
requirements:
  - class: SubworkflowFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: NetworkAccess
    networkAccess: true
  
inputs:
  input: File
  taxid: int
  naming_sqlite: File
  taxon_db: File
  gc_cache: File
  asn_cache: Directory[]
  blast_hits_cache: File?
  genus_list: int[]
  blastdb: string[]
  scatter_gather_nchunks: string
  gencoll_asn: File
steps:
  get_prokaryotic_assembly_for_orthology:
    label: "Get Prokaryotic Assembly For Orthology"
    run: ../progs/get_orthologous_assembly.cwl
    in: 
      unicoll_sqlite: naming_sqlite
      taxon_db: taxon_db
      taxid: taxid
    out: [output]

    
  bacterial_orthology:
    in:
      input: input
      taxid: taxid
      naming_sqlite: naming_sqlite
      taxon_db: taxon_db
      gc_cache: gc_cache
      asn_cache: asn_cache
      blast_hits_cache: blast_hits_cache
      genus_list: genus_list
      blastdb: blastdb
      scatter_gather_nchunks: scatter_gather_nchunks
      gencoll_asn: gencoll_asn
      gc_id_list_orth: 
        source: get_prokaryotic_assembly_for_orthology/output
        loadContents: true
    run: wf_bacterial_orthology.cwl
    when: ${var lines = inputs.gc_id_list_orth.contents.split('\n'); for(var i=0; i<lines.length; i++) { var line=lines[i]; if (line.length == 0) continue; if (line.charAt(0) != '#' && line.charAt(0)!=' ') return true; } return false;   } 
    out: [output]

outputs:
  output:
    type: File
    outputSource:
      - bacterial_orthology/output
      - input
    pickValue: first_non_null    
