cwlVersion: v1.0
label: "Prepare Unannotated Sequences"
doc: "Note that this implementation skips asn validation steps. Please fix"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: True

#bacterial_prepare_unannotated -asn-cache sequence_cache -gc-assembly-manifest gencoll_asn.mft -ids-manifest ids.mft -master-desc master_desc.asn -o sequences.asn -submit-block-manifest submit_block_template.mft -submission-mode-genbank
baseCommand: bacterial_prepare_unannotated
arguments: [ -submission-mode-genbank ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  gc_assembly:
    type: File
    inputBinding:
      prefix: -gc-assembly
  ids:
    type: File
    inputBinding:
      prefix: -ids
  submit_block:
    type: File
    inputBinding:
      prefix: -submit-block
  master_desc_name:
    type: string?
    default: master-desc.asn
    inputBinding:
      prefix: -master-desc
  sequences_name:
    type: string?
    default: sequences.asn
    inputBinding:
      prefix: -o

outputs:
  asncache:
    type: Directory
    outputBinding:
      glob: $(inputs.asn_cache.basename)
  master_desc:
    type: File
    outputBinding:
      glob: $(inputs.master_desc_name)
  sequences:
    type: File
    outputBinding:
      glob: $(inputs.sequences_name)
   
