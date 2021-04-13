#!/usr/bin/env cwl-runner
label: bacterial_orthology
cwlVersion: v1.2
class: Workflow    
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  
inputs:
  input: File
  taxid: int
  naming_sqlite: File
  taxon_db: File
  gc_cache: File
  asn_cache: Directory[]
  blast_hits_cache: File
  genus_list: int[]
  blastdb: 
    type: string[]
    default: blastdb
  scatter_gather_nchunks: string
  gencoll_asn: File
outputs:
  output:
    type: File
    outputSource: propagate_symbols_to_genes/output
steps:
  prepare_annotation_input:
    label: "Prepare Annotation Input"
    run: ../progs/asn_translator.cwl
    in:
      input: input
    out: [output]
  get_prokaryotic_assembly_for_orthology:
    label: "Get Prokaryotic Assembly For Orthology"
    run: ../progs/get_orthologous_assembly.cwl
    in: 
      unicoll_sqlite: naming_sqlite
      taxon_db: taxon_db
      taxid: taxid
    out: [output]
  get_assemblies_for_orthologs_gencoll_asn:
    label: "Get Assemblies for Orthologs GenColl ASN"
    run: ../task_types/tt_gcaccess_from_list.cwl
    in:
      gc_id_list: get_prokaryotic_assembly_for_orthology/output
      gc_cache: gc_cache
    out: [gencoll_asn]
  get_ortholog_nucleotide_ids:
    label: "Get Assemblies for Orthologs GenColl ASN/nucleotide ids"
    run: ../progs/gc_get_molecules.cwl
    in:
      gc_assembly: get_assemblies_for_orthologs_gencoll_asn/gencoll_asn
    out: [molecules]
    
  extract_protein_references_for_orthology:
    label: "Extract Orthologous Prokaryotic Proteins"
    run: ../progs/protein_extract.cwl
    in:
      input: get_ortholog_nucleotide_ids/molecules
      nogenbank: 
        default: true
    out: [proteins, lds2, seqids]
  extract_protein_targets_for_orthology:
    label: "Extract Protein Targets for Orthology"
    run: ../progs/protein_extract.cwl
    in:
      input: input
      nogenbank: 
        default: true
    out: [proteins, lds2, seqids]
  create_orthologous_prokaryotic_protein_blastdb:
    label: "Create Orthologous Prokaryotic Protein BLASTdb"
    run: ../progs/gp_makeblastdb.cwl
    in:
      asn_cache: asn_cache
      ids: extract_protein_references_for_orthology/seqids
      molecules: extract_protein_references_for_orthology/proteins
      lds2: extract_protein_references_for_orthology/lds2
      dbtype: 
        default: prot
      title:
        default: 'protein database for orhology graph'
    out: [blastdb]
  blastp_current_prokaryotic_proteins_vs_orthologs:
    run: ../task_types/tt_blastp_wnode_naming.cwl
    in:
      scatter_gather_nchunks: scatter_gather_nchunks
      # files/directories
      ids: 
          source: [extract_protein_targets_for_orthology/seqids]
          linkMerge: merge_flattened
      lds2: extract_protein_targets_for_orthology/lds2
      proteins: extract_protein_targets_for_orthology/proteins
      blastdb_dir: create_orthologous_prokaryotic_protein_blastdb/blastdb
      blastdb:
        source: 
          - blastdb 
        linkMerge: merge_flattened
      affinity: 
          default: subject
      asn_cache: asn_cache
      align_filter: 
          default: 'score>0 && pct_identity_gapopen_only > 35' 
      allow_intersection: 
          default: true
      comp_based_stats:   
          default: F
      compart: 
          default: true
      dbsize: 
          default: '6000000000'
      delay:
          default: 0
      evalue: 
          default: 0.1
      max_batch_length: 
          default: 10000
      max_jobs: 
          default: 1
      max_target_seqs: 
          default: 50
      no_merge: 
          default: false
      nogenbank: 
          default: true
      ofmt: 
          default: asn-binary
      seg: 
          default:  '30 2.2 2.5'
      soft_masking:
          default: 'yes'
      threshold: 
          default: 21
      top_by_score: 
          default: 10
      word_size: 
          default: 6
      taxid: taxid
      genus_list: genus_list
      blast_hits_cache: 
        source: blast_hits_cache
      blast_type:
        default: 'predicted-protein'
      taxon_db: taxon_db
    out: [blast_align]
  find_prokarotic_orthologs:
    label: "Find Prokaryotic Orthologs"
    run: ../progs/find_orthologs.cwl
    in:
      gc1: gencoll_asn 
      gc2: get_assemblies_for_orthologs_gencoll_asn/gencoll_asn
      annots1: input
      prot_hits: blastp_current_prokaryotic_proteins_vs_orthologs/blast_align
      asn_cache: asn_cache
    out: [orthologs]
  propagate_symbols_to_genes:
    label: "Propagate symbols to genes"
    run: ../progs/propagate_symbols_to_genes.cwl
    in:
      orthologs: find_prokarotic_orthologs/orthologs
      input: input
      
    out: [output]
      