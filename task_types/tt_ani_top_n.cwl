cwlVersion: v1.0
label: "ani_top_n"
# file: task_types/tt_ani_top_n.cwl
class: Workflow # task type
inputs:
  gencoll_asn: File
  blast_align: File
  ANI_cutoff: File
  asn_cache: Directory[]
  ref_assembly_id: int
  ref_assembly_taxid: int
  taxon_db: File
  tax_synon: File
  gcextract2_sqlite: File
outputs:
  top:
    type: File
    outputSource: ani_top_identification/top
  annot:
    type: File
    outputSource: ani_top_identification/annot
    
steps:
  ani_top_identification:
    run: ../progs/ani_top_identification.cwl
    in:
      ANI_cutoff: ANI_cutoff
      N: 
        default: 25
      asn_cache: asn_cache
      input: blast_align
      min_gap: 
        default: 10000
      min_region: 
        default: 100
      query_assembly: gencoll_asn
      ref_assembly_id: ref_assembly_id
      ref_assembly_taxid: ref_assembly_taxid
      tax_synon: tax_synon
      taxon_db: taxon_db
      gcextract2_sqlite: gcextract2_sqlite
    out: [annot, top]
