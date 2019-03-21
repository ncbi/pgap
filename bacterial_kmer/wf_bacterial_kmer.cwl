#!/usr/bin/env cwl-runner
label: bacterial_kmer
cwlVersion: v1.0
class: Workflow 
requirements: 
    - class: SubworkflowFeatureRequirement    
    - class: MultipleInputFeatureRequirement
    
inputs:
    Extract_Kmers_From_Input___entry: File
    gencoll_asn: File
    asn_cache: Directory
    kmer_cache_sqlite: File
    kmer_cache_uri: string
    ref_assembly_taxid: int
    ANI_cutoff: File
    kmer_reference_assemblies: File
outputs:
    Identify_Top_N_ANI_annot:
        type: File
        outputSource: Identify_Top_N_ANI/annot
    Identify_Top_N_ANI_top:
        type: File
        outputSource: Identify_Top_N_ANI/top
    Extract_Top_Assemblies___tax_report:
        type: File
        outputSource: Extract_Top_Assemblies/tax_report
steps:
  # 
  # Internal PGAP step "Get Reference Assemblies" ommitted it's a const, repplaced by 
  #     kmer_reference_assemblies
  # Internal PGAP step "Query_Kmer_Cache:
  #     This task node in classic PGAP converts list of gcids to a list of URIS
  #     we do not need to do the conversion, since kmer_store is capable of recognising list of URIs
  # Internal PGAP step "Extract_Kmer_List":
  #     This task node in classic PGAP takes the list of new reference assemblies and computes kmer hashes 
  #     We do not need to do this here, because external PGAP will be always supplied with up to date
  #     reference assemblies 
  # Internal PGAP step "Store_in_Kmer_Cache":
  #     Stores input kmer cache file (local to buildrun directory) in global storage
  #     We do not need to do this here, because external PGAP will be always supplied with up to date
  #     reference assemblies 
  Extract_Kmers_From_Input:
    label: Extract Kmers From Input
    run: ../task_types/tt_kmer_seq_entry_extract_wnode.cwl
    doc: |
        computes kmers for input genome (Extract_Kmers_From_Input___entry)
        produces kmer files (.gz and xml)
        it will have a new output: out_kmer_dir
    in:
      entry: Extract_Kmers_From_Input___entry
      kmer_file_list: 
        source: [kmer_reference_assemblies]
        linkMerge: merge_flattened
      asn_cache: asn_cache
    out: [out_kmer_dir]
  Convert_kmer_files_to_sqlite:
    label: Convert Kmer files to SQLITE
    doc: |
        This new step will convert input .kmer.gz (kmer_file) and .xml (kmer_metadata_file)
        into new sqlite database
        The program we are calling here takes a directory input
    run: ../progs/kmer_files2sqlite.cwl
    in:
        kmer_dir: Extract_Kmers_From_Input/out_kmer_dir
    out: [out_kmer_cache_sqlite]
  List_sqlite:
        label: List SQLITE kmer cache contents
        doc: Produces the list of all keys in sqlite database
        run: ../progs/list_kmer_sqlite.cwl
        in:
            kmer_cache_sqlite: Convert_kmer_files_to_sqlite/out_kmer_cache_sqlite
        out: [keys]
  Combine_kmer_sqlite:
        label: Combine kmer SQLITE
        doc: |
            This new step will combine together reference kmer store and newly created kmer store for a new assembly
        run: ../progs/combine_kmer_sqlite.cwl
        in:
            kmer_cache_sqlite: 
                source: [kmer_cache_sqlite, Convert_kmer_files_to_sqlite/out_kmer_cache_sqlite]
                linkMerge: merge_flattened
        out: [combined_cache_sqlite]
  Compare_Kmer:
    label: Compare Kmer
    doc: |
        compares kmers from different genomes in the input and produces distance matrix
        filled only for ref vs current elements
    run: ../task_types/tt_kmer_ref_compare_wnode.cwl
    in:
      kmer_cache_sqlite: Combine_kmer_sqlite/combined_cache_sqlite
      kmer_list: List_sqlite/keys
      ref_kmer_list:   kmer_reference_assemblies
      dist_method:
        default: minhash
      minhash_signature:
        default: minhash
      score_method:
        default: boolean
    out: [distances, outdir]
  Identify_Top_N:
    label: Identify Top N hits by Kmer
    doc: |
        Identifies Top N hits to input genome by kmer distances 
        produces distances XML and list of matching genomes (storage URIs)
    run: ../task_types/tt_kmer_top_n.cwl
    in:
      kmer_cache_sqlite: Combine_kmer_sqlite/combined_cache_sqlite    
      distances: Compare_Kmer/distances
    out: [matches, top_distances]
  Compare_Kmer_Pairwise_prepare_input:
        label: Glue SQLITE keys
        run: ../progs/cat.cwl
        in:
            input:
                source: [List_sqlite/keys, Identify_Top_N/matches]
                linkMerge: merge_flattened
            output_file_name:
                default: 'target_and_matches.ids'
        out: [output]
  Compare_Kmer__Pairwise_:
    label: Compare Kmer pairwise
    doc: |
        compares kmers from top hits to query genome in the input and produces distance matrix for subsequent tree: all-against-all. This is the most downstream node requiring sqlite cache
    run: ../task_types/tt_kmer_compare_wnode.cwl
    in:
      kmer_cache_sqlite: Combine_kmer_sqlite/combined_cache_sqlite    
      kmer_list: Compare_Kmer_Pairwise_prepare_input/output
      dist_method:
            default: minhash
      minhash_signature:
        default: minhash
      score_method:
        default: boolean
    out: [distances]
  Extract_Top_Assemblies:
    label: Extract Top Assemblies
    doc: |
        Takes XML file with top distances between matches and reference assembly taxid
        produces XML tax report and list of top matched assemblies 
    run: ../task_types/tt_kmer_top_n_extract.cwl
    in:
      top_distances: Identify_Top_N/top_distances
      ref_assembly_taxid: ref_assembly_taxid
    out: [tax_report, gc_id_list]
  Build_Kmer_Tree:
    label: Build Kmer Tree
    doc: Output is BioTree ASN.1
    run: ../task_types/tt_kmer_build_tree.cwl
    in:
        distances: Compare_Kmer__Pairwise_/distances
        sort:
            default: leaf-count-ascending
        no_merge:
            default: true
        skip_markup:
            default: true
    out: [tree]
  Get_Top_Assemblies_GenColl_ASN:
    label: Get Top Assemblies GenColl ASN
    doc: Input is list of reference assemblies, not to be mixed with list of URIs
    run: ../task_types/tt_gcaccess_from_list.cwl
    in:
      gc_id_list: Extract_Top_Assemblies/gc_id_list
    out: [gencoll_asn]
  Extract_Input_GenColl_IDs:
    label: Extract Input Gencoll IDs
    doc: Input is a target assembly, not to be mixed with list of URIs
    run: ../task_types/tt_extract_gencoll_ids.cwl
    in: 
        assemblies: gencoll_asn
    out: [gc_id_list]
  Assembly_Assembly_BLASTn:
    label: Assembly Assembly BLASTn
    doc: This is rather standard blast
    run: ../task_types/tt_assm_assm_blastn_wnode.cwl
    in:
      queries_gc_id_list: Extract_Input_GenColl_IDs/gc_id_list
      subjects_gc_id_list: Extract_Top_Assemblies/gc_id_list
      # this will brea here
      ref_gencoll_asn: Get_Top_Assemblies_GenColl_ASN/gencoll_asn
      gencoll_asn: gencoll_asn
      affinity:
        default: 'subject'
      # settings
      asn_cache: asn_cache
      compart: 
        default: "true"
      evalue: 
        default: 0.0001
      gapextend: 
        default: 1
      gapopen: 
        default: 2
      max_bases_per_call: 
        default: 500000000
      max_target_seqs: 
        default: 250
      merge_align_filter: 
        default: "((reciprocity = 3 AND align_length_ungap >= 5) OR align_length > 1000) AND pct_identity_gap > 25"
      merge_engine: 
        default: "tree-merger"
      soft_masking:  
        default: "true"
      task:  
        default: megablast
      use_common_components:  
        default: "true"
      window_size:  
        default: 150
      word_size:  
        default: 28
      workers_per_cpu:  
        default:  0.4
    out: [blast_align]
  Identify_Top_N_ANI:
    doc: identify top N ANI
    label: "Identify Top N ANI"
    run: ../task_types/tt_ani_top_n.cwl
    in:
        asn_cache: asn_cache
        ANI_cutoff: ANI_cutoff
        gencoll_asn: gencoll_asn
        blast_align: Assembly_Assembly_BLASTn/blast_align
        ref_assembly_taxid: ref_assembly_taxid
    out: [top,annot]
