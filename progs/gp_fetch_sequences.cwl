cwlVersion: v1.2
label: "gp_fetch_sequences"

class: CommandLineTool
requirements:
 - class: InitialWorkDirRequirement
   listing:
     - entry: $(inputs.proteins)
       writable: false
baseCommand: gp_fetch_sequences
arguments: [ -nogenbank ]
inputs:
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  input: 
    type: File
    inputBinding:
        prefix: -input
  lds2: 
    type: File?
    inputBinding:
        prefix: -lds2        
  proteins: 
    type: File?
  out_asn_name:
    type: string?
    default: out_asn_name.asn
    inputBinding:
        prefix: -o        
outputs:
    output:
        type: File
        outputBinding:
            glob: $(inputs.out_asn_name)

    
