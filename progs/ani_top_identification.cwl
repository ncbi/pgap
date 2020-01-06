cwlVersion: v1.0 
label: "ani_top_identification"

# file: progs/ani_top_identification.cwl
class: CommandLineTool
baseCommand: ani_top_identification
arguments: [ -nogenbank ]
inputs:
      ANI_cutoff:   
        type: File
        inputBinding:
            prefix: -ANI_cutoff
      N: 
        type: int?
        inputBinding:
            prefix: -N
      asn_cache:
        type: Directory[]
        inputBinding:
          prefix: -asn-cache
          itemSeparator: ","
      input: 
        type: File?
        inputBinding:
            prefix: -input
      min_gap: 
        type: int?
        inputBinding:
            prefix: -min-gap
      min_region: 
        type: int?
        inputBinding:
            prefix: -min-region
      query_assembly: 
        type: File
        inputBinding:
            prefix: -query-assembly
      ref_assemblies: 
        type: File
        inputBinding:
            prefix: -ref-assemblies
      ref_assembly_id: 
        type: int?
        inputBinding:
            prefix: -ref-assembly-id
      ref_assembly_taxid: 
        type: int?
        inputBinding:
            prefix: -ref-assembly-taxid
      tax_synon:
        type: File
        inputBinding:
            prefix: -tax-syn-table
      taxon_db:
        type: File
        inputBinding:
            prefix: -taxon-db
      gcextract2_sqlite:
        type: File
        inputBinding:
            prefix: -gcextract2-sqlite
      o:
        type: string?
        default: ani-tax-report.xml
        inputBinding:
            prefix: -o
      o_annot:
        type: string?
        default: annot.asn
        inputBinding:
            prefix: -o-annot
outputs:
    annot:
        type: File
        outputBinding:
            glob: $(inputs.o_annot)
    top:
        type: File
        outputBinding:
            glob: $(inputs.o)
