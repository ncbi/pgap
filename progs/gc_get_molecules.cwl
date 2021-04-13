cwlVersion: v1.2
label: "gc_get_molecules"

class: CommandLineTool
#
# You might need something like this:
#
# requirements:
#  - class: InitialWorkDirRequirement
#    listing:
#      - entry: $(inputs.asn_cache)
#        writable: True
#      - entry: $(inputs.blastdb_dir)
#        writable: False

baseCommand: gc_get_molecules
arguments: [ -nogenbank ]
inputs:
  filter:
    type: string?
    default: all
    inputBinding:
      prefix: -filter
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  level:
    type: string?
    default: top-level
    inputBinding:
      prefix: -level
      
  output_name:
    type: string?
    default: assembly.molecules.ids
    inputBinding:
      prefix: -output
      
outputs:
  molecules:
    type: File
    outputBinding: 
      glob: $(inputs.output_name)