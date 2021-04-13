cwlVersion: v1.2
label: find_orthologs
class: CommandLineTool
baseCommand: find_orthologs
inputs:
  gc1: 
    type: File
    inputBinding:
      prefix: -gc1
  gc2: 
    type: File
    inputBinding:
      prefix: -gc2
  annots1: 
    type: File
    inputBinding:
      prefix: -annots1
  prot_hits: 
    type: File[]
    inputBinding:
      prefix: -prot_hits
      itemSeparator: "_if_you_see_this_do_not_supply_more_than_one_item_"
  check_exome:
    type: boolean
    default: true
  o_orthologs:
    type: string?
    default: orthologs.rpt
    inputBinding:
      prefix: -o_orthologs
       
  o_stats:
    type: string?
    default: stats.xml 
    inputBinding:
      prefix: -o_stats
  asn_cache: 
    type: Directory[]
    inputBinding:
      prefix: -asn_cache
      # at this point we do not know if find_ortholos binary supports this:
      itemSeparator: ","
      # .. but we know that we will be supplying only arrays of size 1 to this
outputs:
  orthologs:
    type: File
    outputBinding: 
      glob: $(inputs.o_orthologs)  
      