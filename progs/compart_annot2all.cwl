# called by Extract_Proteins_From_Compartments
cwlVersion: v1.2
class: CommandLineTool
baseCommand: compart_annot2all
label: compart_annot2all
arguments: [ -ofmt, 'reference-id' ]
inputs:
  aligns:
    type: File
    inputBinding:
      prefix: -input
  seqids_name:
    type: string
    default: reference_protein.seqids
    inputBinding:
      prefix: -out
      
outputs:
  seqids:
    type: File
    outputBinding:
      glob: $(inputs.seqids_name)      