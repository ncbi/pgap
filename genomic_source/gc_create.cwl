cwlVersion: v1.0
label: "Create Assembly From Sequences"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False

#gc_create -unplaced-manifest sequences.mft -asn-cache sequence_cache -gc-assm-name L103 -o gencoll.asn
baseCommand: gc_create
inputs:
  unplaced:
    type: File
    inputBinding:
      prefix: -unplaced
  gc_assm_name:
    type: string
    inputBinding:
      prefix: -gc-assm-name
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  outfile:
    type: string?
    default: gencoll.asn
    inputBinding:
      prefix: -o
      
outputs:
  gencoll_asn:
    type: File
    outputBinding:
      glob: $(inputs.outfile)
