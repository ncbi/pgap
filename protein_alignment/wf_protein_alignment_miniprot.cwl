#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: Workflow

label: "Align reference proteins plane complete workflow, with miniprot"
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  
inputs:
  asn_cache: Directory
  uniColl_asn_cache: Directory
  all_prots: File # Get_Proteins/all_prots
  genomic_ids: File
  blastdb_dir: Directory # genomic
  compartments: File # Map_Naming_Hits/compartments

  taxid: int
  taxon_db: File
outputs:
  align:  
    type: File
    outputSource: Filter_Protein_Alignments/align

steps: 
  # order: left-right, top-down
  Extract_Proteins_From_Compartments:
    run: ../progs/compart_annot2all.cwl 
    in: 
      aligns: compartments
    out: [seqids]
# old one: Get Proteins out: [ universal_clusters, all_prots, selected_blastdb ] 
  Get_Protein_FASTA:
    run: ../progs/getfasta.cwl
    in: 
      gilist:
        source:
          - Extract_Proteins_From_Compartments/seqids
          - all_prots
        linkMerge: merge_flattened
      asn_cache:
        source:
          - asn_cache
          - uniColl_asn_cache
        linkMerge: merge_flattened
    out: [fasta]
  Get_Genomic_FASTA:
    # note: this looks like a swiss-knife application
    run: ../progs/cross_origin_fasta.cwl
    in:
      gilist: genomic_ids
      action: 
        default: 'create'
      asn_cache: 
        source: [asn_cache]
        linkMerge: merge_flattened
    out: [delta_seqs, fasta]
  Filter_Short_Sequences:
    run: ../progs/seq_filter.cwl
    in:
      seqids:
        source:
          - Extract_Proteins_From_Compartments/seqids
          - all_prots
        linkMerge: merge_flattened
      asn_cache:
        source:
          - asn_cache
          - uniColl_asn_cache
        linkMerge: merge_flattened
      
    out: [match]
  Run_Miniprot_slow:
    run: ../progs/miniprot.cwl
    in:
      genome: Get_Genomic_FASTA/fasta
      proteins: Get_Protein_FASTA/fasta
      miniprot_params: 
        default: '-S -G 500 -e 500 -p 0.01 --outs 0.01 --outc 0.01 -B 0 -L 15 -k 5 -l 4 -n 2 -N 1000'
      cpu_count: 
        default: 16
    out: [paf]
  Run_Miniprot_fast:
    run: ../progs/miniprot.cwl
    in:
      genome: Get_Genomic_FASTA/fasta
      proteins: Get_Protein_FASTA/fasta
      miniprot_params: 
        default: '-p 0.01 --outs 0.01 --outc 0.01 -S -L 15 -n 2 -N 1000'
      cpu_count: 
        default: 16
    out: [paf]    
  Compute_Gencode:
    run: ../progs/compute_gencode.cwl
    in:
        taxid: taxid
        taxon_db: taxon_db
        gencode: 
            default: true
    out: [ output ]
  Compute_Gencode_int:
    run: ../progs/file2int.cwl
    in:
        input: Compute_Gencode/output
    out: [ value ]
    
  Align_Short_Proteins:
    run: wf_seed_seqids.cwl
    in: 
      blastdb_dir: blastdb_dir
      seqids: Filter_Short_Sequences/match
      db_gencode: Compute_Gencode_int/value
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache

      
    out: [blast_align]
  Convert_PAF_Alignments:
    run: ../progs/paf2asn.cwl
    in:
      asn_cache:
        source:
          - asn_cache
          - uniColl_asn_cache
        linkMerge: merge_flattened
      paf:
        source:
          - Run_Miniprot_fast/paf
          - Run_Miniprot_slow/paf
        linkMerge: merge_flattened
    out: [align]
    
  Sort_Short_Protein_Alignments:
    run: ../progs/align_sort_ma.cwl
    in: 
      asn_cache:
        source:
          - asn_cache
          - uniColl_asn_cache
        linkMerge: merge_flattened
      input: Align_Short_Proteins/blast_align
      ifmt: 
        default: 'seq-align-set'
      k:
        default: 'query subject'
      nogenbank: 
        default: true
    out: [output]
  Remap_cross_origin_alignments:
    # note: this looks like a swiss-knife application  
    run: ../progs/cross_origin_fasta.cwl
    in:
      align: Convert_PAF_Alignments/align
      delta_seqs_input: Get_Genomic_FASTA/delta_seqs
      min_pct_ident:
        default: 0.3
      window:
        default: 21
      action:
        default: remap
      asn_cache:
        source:
          - asn_cache
          - uniColl_asn_cache
        linkMerge: merge_flattened
    out: [mapped_aligns]
  Filter_Full_Coverage_Alignments:
  
    run: bacterial_protalign_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      filter_accept: 
        default: 'pct_coverage >= 70'
      max_extent: 
        default: 100 
      sorted_seeds: Sort_Short_Protein_Alignments/output
    out: [blast_full_cov]

  Filter_Protein_Compartments:
    run: ../progs/align_filter.cwl
    in: 
      asn_cache: 
        source: [asn_cache]
        linkMerge: merge_flattened
      compartments: 
        source: [compartments]
        linkMerge: merge_flattened
      input: 
        source:
          - Filter_Full_Coverage_Alignments/blast_full_cov
          - Remap_cross_origin_alignments/mapped_aligns
        linkMerge: merge_flattened
      subject_allowlist: all_prots

      filter:
          default: 'subject_coverage >= 10'
      ifmt:
          default: seq-align
      nogenbank:
          default: true      
    out: [o]
        
  Sort_Protein_Alignments:
    run: ../progs/align_sort.cwl 
    in:
      input: Filter_Protein_Compartments/o
      asn_cache: asn_cache
      ifmt:
        default: seq-align
      k:
        default: query,subject,-score,cigar
      nogenbank:
        default: true
        
    out: [output]
  Filter_Protein_Alignments:
    run: align_filter.cwl
    in:
      asn_cache: asn_cache
      uniColl_asn_cache: uniColl_asn_cache
      # filter: # we are calling with the same filter as before miniprot, no need 
      # to drag this out from arguments: field in CommandLineTool
      file_in: Sort_Protein_Alignments/output
      
    out: [ align]

