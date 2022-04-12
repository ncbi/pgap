#!/usr/bin/env cwl-runner
label: bacterial_orthology
cwlVersion: v1.2
class: Workflow    
requirements:
  - class: SubworkflowFeatureRequirement
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
  gc_id_list_orth: File
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
      output_name: { default: 'input_text.asn' }
    out: [output]
  get_assemblies_for_orthologs_gencoll_asn:
    label: "Get Assemblies for Orthologs GenColl ASN"
    run: ../task_types/tt_gcaccess_from_list.cwl
    in:
      gc_id_list: gc_id_list_orth
      gc_cache: gc_cache
    out: [gencoll_asn]
  get_ortholog_nucleotide_ids:
    label: "Get Assemblies for Orthologs GenColl ASN/nucleotide ids"
    run: ../progs/gc_get_molecules.cwl
    in:
      gc_assembly: get_assemblies_for_orthologs_gencoll_asn/gencoll_asn
    out: [molecules]
  extract_ortholog_nucleotide_asn:
    label: "Extract Orthologous Prokaryotic Proteins: fetch nucleotide ASN.1"
    run: ../progs/gp_fetch_sequences.cwl
    in:
      asn_cache: asn_cache
      input: get_ortholog_nucleotide_ids/molecules
      out_asn_name: {default: 'orhologous.nucleotide.asn'}
    out: [output]
  
  extract_protein_references_for_orthology:
    label: "Extract Orthologous Prokaryotic Proteins"
    run: ../progs/protein_extract.cwl
    in:
      input: extract_ortholog_nucleotide_asn/output
      nogenbank: 
        default: true
    out: [proteins]
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
      asnb: extract_protein_references_for_orthology/proteins
      dbtype: 
        default: prot
      title:
        default: 'protein database for orhology graph'
    out: [blastdb]
  blastp_current_prokaryotic_proteins_vs_orthologs:
    label: "BLASTp Current Prokaryotic Proteins vs Orthologs"
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
          default: 0.001
      max_batch_length: 
          default: 10000
      max_jobs: 
          default: 1
      max_target_seqs: 
          default: 250
      no_merge: 
          default: false
      nogenbank: 
          default: true
      ofmt: 
          default: asn-binary
      seg: 
          default:  'no'
      threshold: 
          default: 21
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
  cat_aligns:
    label: "BLASTp Current Prokaryotic Proteins vs Orthologs/cat aligns"
    run: ../progs/cat.cwl
    in: 
      input: blastp_current_prokaryotic_proteins_vs_orthologs/blast_align
      output_file_name: { default: 'blastp.align.asn' }
    out: [output]
      
  find_prokarotic_orthologs:
    label: "Find Prokaryotic Orthologs"
    run: ../progs/find_orthologs.cwl
    in:
      gc1: gencoll_asn 
      gc2: get_assemblies_for_orthologs_gencoll_asn/gencoll_asn
      annots1: prepare_annotation_input/output
      prot_hits: cat_aligns/output
      asn_cache: asn_cache
    out: [orthologs]
  propagate_symbols_to_genes:
    label: "Propagate symbols to genes"
    run: ../progs/propagate_symbols_to_genes.cwl
    in:
      orthologs: find_prokarotic_orthologs/orthologs
      input: prepare_annotation_input/output
      it:  
        default: true
      
    out: [output]
      