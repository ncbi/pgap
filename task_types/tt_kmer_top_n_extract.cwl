cwlVersion: v1.0
label: "kmer_top_n_extract"
# file: tt_kmer_top_n_extract.cwl
class: Workflow # task type
inputs:
  top_distances: File
  ref_assembly_taxid: int
  ref_assembly_id: int
  taxon_db: File
outputs:
  tax_report:
    type: File
    outputSource: kmer_top_n_extract/tax_report
  gc_id_list:
    type: File
    outputSource: kmer_top_n_extract/gc_id_list
steps:
  kmer_top_n_extract:
    run: ../progs/kmer_top_n_extract.cwl
    in:
      input: top_distances
      ref_assembly_id:  ref_assembly_id
      ref_assembly_taxid: ref_assembly_taxid
      taxon_db: taxon_db
      threshold: 
        default: 0.1
    out: [tax_report , gc_id_list]
