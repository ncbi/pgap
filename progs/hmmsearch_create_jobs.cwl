cwlVersion: v1.0
label: "hmmsearch_create_jobs"

class: CommandLineTool
hints:

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.hmm_path)
        writable: False
    
#hmmsearch_create_jobs -hmm-manifest real_hmms_combined.mft -output jobs.xml -seqids proteins.seq_ids -workpath workpath -no-merge-hmms
baseCommand: hmmsearch_create_jobs
arguments: [ -no-merge-hmms ]
inputs:
  hmm_path:
    type: Directory
    inputBinding:
      prefix: -hmm-path
  seqids:
    type: File
    inputBinding:
      prefix: -seqids
  output:
    type: string?
    default: jobs.xml
    inputBinding:
      prefix: -output
  workpath:
    type: string?
    default: workpath
    inputBinding:
      prefix: -workpath
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output)
  workdir:
    type: Directory
    outputBinding:
      glob: $(inputs.workpath)

  
  
