#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0
doc: |
  Perform taxonomic identification tasks on an input genome
requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
inputs:
  supplemental_data:
    type: Directory
    default:
      class: Directory
      location: input
  fasta: File
  gc_assm_name:
    type: string
    default: my_gc_assm_name
  report_usage: boolean
  submol: File
  ignore_all_errors:
        type: boolean?
  no_internet:
    type: boolean?
outputs:
  annot:
    type: File
    outputSource: bacterial_kmer/Identify_Top_N_ANI_annot
  ani_tax_report:
    type: File
    outputSource: bacterial_kmer/Identify_Top_N_ANI_top
  kmer_tax_report:
    type: File
    outputSource: bacterial_kmer/Extract_Top_Assemblies___tax_report
steps:
  ping_start:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      make_uuid:
        default: true
      state:
        default: "start"
      workflow:
        default: "ani-analysis"
      instring: gc_assm_name
    out: [stdout, outstring, uuid_out]
  fastaval:
    run: progs/fastaval.cwl
    in:
       in: fasta
       check_min_seqlen:
           default: 200
       check_internal_ns:
           default: true
       ignore_all_errors: ignore_all_errors
    out: [success]
  passdata:
    in:
      data: supplemental_data
    run: expr/ani.cwl
    out:
      - ANI_cutoff
      - gc_cache
      - gc_seq_cache
      - gcextract2_sqlite
      - kmer_cache_sqlite
      - kmer_reference_assemblies
      - taxon_db
      - tax_synon
  prepare_input_template:
    run: prepare_user_input2.cwl
    label: Prepare user input
    in:
      fasta: fasta
      submol: submol
      taxon_db: passdata/taxon_db
      ignore_all_errors: ignore_all_errors
      no_internet: no_internet
    out: [output_seq_submit, output_entries, locus_tag_prefix, submol_block_json, taxid]
  
  Prepare_Seq_entries:
    run: progs/prepare_seq_entry_input.cwl
    in: 
        entries: prepare_input_template/output_entries
        seq_submit: prepare_input_template/output_seq_submit
    out: [output_entries]

  genomic_source: 
    run: genomic_source/wf_genomic_source_asn.cwl
    in:
      entries: prepare_input_template/output_entries
      seq_submit: prepare_input_template/output_seq_submit
      gc_assm_name: ping_start/outstring
      taxon_db: passdata/taxon_db
    out: [gencoll_asn, seqid_list, stats_report, asncache, ids_out, submit_block_template]  
  bacterial_kmer:
    run: bacterial_kmer/wf_bacterial_kmer.cwl
    in:
      Extract_Kmers_From_Input___entry: Prepare_Seq_entries/output_entries
      gencoll_asn: genomic_source/gencoll_asn
      asn_cache: genomic_source/asncache
      gc_seq_cache: passdata/gc_seq_cache
      gc_cache: passdata/gc_cache
      kmer_cache_sqlite: passdata/kmer_cache_sqlite
      ref_assembly_taxid: prepare_input_template/taxid
      ref_assembly_id: 
        default: 0
      ANI_cutoff: passdata/ANI_cutoff
      kmer_reference_assemblies: passdata/kmer_reference_assemblies
      tax_synon: passdata/tax_synon
      taxon_db: passdata/taxon_db
      gcextract2_sqlite: passdata/gcextract2_sqlite
      
    out:     [Identify_Top_N_ANI_annot, Identify_Top_N_ANI_top, Extract_Top_Assemblies___tax_report]

  ping_stop:
    run: progs/pinger.cwl
    in:
      report_usage: report_usage
      uuid_in: ping_start/uuid_out
      state:
        default: "stop"
      workflow:
        default: "ani-analysis"
      # Note: the input on the following line should be the same as all of the outputs
      # for this workflow, so we ensure this is the final step.
      infile:
        - bacterial_kmer/Identify_Top_N_ANI_annot
        - bacterial_kmer/Identify_Top_N_ANI_top
        - bacterial_kmer/Extract_Top_Assemblies___tax_report
    out: [stdout]
