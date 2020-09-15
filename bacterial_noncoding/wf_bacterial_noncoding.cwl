#!/usr/bin/env cwl-runner
label: "Non-Coding Bacterial Genes"
cwlVersion: v1.0
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  go: 
        type: boolean[]
  asn_cache: Directory
  seqids: File
  model_path_5s: File
  model_path_16s: File
  model_path_23s: File
  rfam_amendments: File
  rfam_stockholm: File
  taxon_db: File

outputs:
  # asncache:
  #   type: Directory
  #   outputSource: bacterial_noncoding_16S/asncache
  annotations_5s:
    type: File
    outputSource: annot_ribo_operons/output_5S
  annotations_16s:
    type: File
    outputSource: annot_ribo_operons/output_16S
  annotations_23s:
    type: File
    outputSource: annot_ribo_operons/output_23S
    
steps:
  bacterial_noncoding_5S:
    run: wf_gcmsearch.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
      model_path: model_path_5s
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
      taxon_db: taxon_db
    out: [ annots ]

  bacterial_noncoding_16S:
    run: wf_gcmsearch.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
      model_path: model_path_16s
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
      taxon_db: taxon_db
    out: [ annots ]
    
  bacterial_noncoding_23S:
    run: wf_gcmsearch.cwl
    in:
      asn_cache: asn_cache
      seqids: seqids
      model_path: model_path_23s
      rfam_amendments: rfam_amendments
      rfam_stockholm: rfam_stockholm
      taxon_db: taxon_db
    out: [ annots ]


  annot_ribo_operons:
    run: ../progs/annot_ribo_operons.cwl
    in:
      input_5S: bacterial_noncoding_5S/annots
      input_16S: bacterial_noncoding_16S/annotations
      input_23S: bacterial_noncoding_23S/annotations
    out: [output_5S, output_16S, output_23S]
    
