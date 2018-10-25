cwlVersion: v1.0 
label: "ani_top_identification"

# file: progs/ani_top_identification.cwl
class: CommandLineTool
hints:
baseCommand: ani_top_identification
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
        type: Directory?
        inputBinding:
            prefix: -asn-cache
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
            prefix: -ANI_cutoff
      ref_assembly_id: 
        type: int?
        inputBinding:
            prefix: -ref-assembly-id
      ref_assembly_taxid: 
        type: int?
        inputBinding:
            prefix: -ref-assembly-taxid
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
