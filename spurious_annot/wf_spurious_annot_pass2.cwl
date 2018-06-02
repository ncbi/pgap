#!/usr/bin/env cwl-runner
label: spurious_annot
cwlVersion: v1.0
class: Workflow    
inputs:
  Search_AntiFam___lds2: File
  Good__AntiFam_filtered_annotations___models: File
  Pass_Input_Proteins___prot_ids: File
  Pass_Input_Proteins_I___prot_ids: File
  Search_AntiFam_I___lds2: File
outputs:
  Good__AntiFam_filtered_proteins___gilist:
    type: File
    outputSource:
  Good__AntiFam_filtered_annotations___annotation:
    type: File
    outputSource:
  AntiFam_tainted_proteins_I___oseqids:
    type: File
    outputSource:
  Good__AntiFam_filtered_annotations___annotation:
    type: File
    outputSource:
steps:
  AntiFam_tainted_proteins:
    run: ../task_types/tt_reduce.cwl:
    in:
      entry: entry
      hmm_hits: hmm_hits
    out: [oseqids]
  AntiFam_tainted_proteins_I:
    run: ../task_types/tt_reduce.cwl:
    in:
      entry: entry
      hmm_hits: hmm_hits
    out: [oseqids]
  Good__AntiFam_filtered_proteins:
    run: ../task_types/tt_set_op_gilist.cwl:
    in:
      gilist: gilist
      prot_ids: prot_ids
      oseqids: oseqids
    out: [gilist]
  Search_AntiFam_I:
    run: ../task_types/tt_hmmsearch_wnode.cwl:
    in:
      models: models
      text: text
      gilist: gilist
      prot_ids: prot_ids
      lds2: lds2
    out: [hmm_hits]
  Get_AntiFam_Models:
    run: ../task_types/tt_const_hmmer_hmm_library_v3.cwl:
    out: [models]
  Get_AntiFam_Models:
    run: ../task_types/tt_const_hmmer_hmm_library_v3.cwl:
    out: [models]
  Search_AntiFam:
    run: ../task_types/tt_hmmsearch_wnode.cwl:
    in:
      models: models
      text: text
      gilist: gilist
      prot_ids: prot_ids
      lds2: lds2
    out: [hmm_hits]
