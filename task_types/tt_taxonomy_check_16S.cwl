cwlVersion: v1.0
label: "taxonomy_check_16S"
class: Workflow # task type
inputs:
  blastdb: string
  blastdb_dir: Directory
  asn_cache: Directory
  align: File
  taxon_db: File
outputs:
  report:
    type: File
    outputSource: taxonomy_check_16S/report
steps:
  taxonomy_check_16S:
    run: ../progs/taxonomy_check_16S.cwl
    in:
      blastdb: blastdb
      blastdb_dir: blastdb_dir
      asn_cache: asn_cache
      ifmt: 
        default: seq-align
      input: align
      top:
        default: 10
      taxon_db: taxon_db
    out: [report]
        
