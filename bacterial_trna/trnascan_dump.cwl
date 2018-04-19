cwlVersion: v1.0
label: "Run tRNAScan, transform"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/bacterial_trna:pgap4.4
    
# trnascan_dump -input intermediate.asn -oasn trnascan.asn -ostruc struc.tar.gz -X 20
baseCommand: trnascan_dump
arguments: [ -X, '20' ]
inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  oasn:
    type: string?
    default: "trnascan.asn"
    inputBinding:
      prefix: -oasn
  ostruct:
    type: string?
    default: "struct.tar.gz"
    inputBinding:
      prefix: -ostruc

outputs:
  outasn:
    type: File
    outputBinding:
      glob: $(inputs.oasn)
  outstruct:
    type: File
    outputBinding:
      glob: $(inputs.ostruct)
