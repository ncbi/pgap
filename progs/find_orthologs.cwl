cwlVersion: v1.2
label: find_orthologs
class: CommandLineTool
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: annots1.mft
       entry: ${var blob = '# annots1.mft created for find_orthologs from input annots1 File\n';  if(inputs.annots1 != null) { blob += inputs.annots1.path + '\n'; } return blob; }
       
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
    type:  File
  annots1impl:
    type: string
    default: annots1.mft
    inputBinding:
      prefix: -annots1
  prot_hits: 
    type: File
    inputBinding:
      prefix: -prot_hits
  check_exome:
    type: boolean
    default: true
    inputBinding:
      prefix: -check_exome
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
      prefix: -asn-cache
      # at this point we do not know if find_ortholos binary supports this:
      itemSeparator: ","
      # .. but we know that we will be supplying only arrays of size 1 to this
outputs:
  orthologs:
    type: File
    outputBinding: 
      glob: $(inputs.o_orthologs)  
      
