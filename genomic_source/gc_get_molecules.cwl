cwlVersion: v1.0
label: "Extract Assembly Information I"
class: CommandLineTool
hints:

# gc_get_molecules -gc-assembly gencoll.asn -level top-level -filter reference-no-organelle -o ref_no_organelle.gi

baseCommand: gc_get_molecules
arguments: [ -level, top-level ]
inputs:
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  filter:
    type: string
    inputBinding:
      prefix: -filter
  outfile:
    type: string
    inputBinding:
      prefix: -o
      
outputs:
  seqid_list:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
