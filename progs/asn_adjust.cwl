cwlVersion: v1.2
label: "asn_adjust"
requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input)
        writable: True
  
class: CommandLineTool
baseCommand: asn_adjust
arguments: ['-fix-prots-to-gnl-id','-t', '-output-path', 'out']

inputs:
  input:
    type: File
    inputBinding:
      prefix: -input
  
outputs:
  entries:
    type: File
    outputBinding:
      glob: $(inputs.input.basename)

  
  
