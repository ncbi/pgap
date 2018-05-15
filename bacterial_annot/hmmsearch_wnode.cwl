cwlVersion: v1.0
label: "HMM Searchers"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/pgap:latest

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.hmm_path)
        writable: False
      - entry: $(inputs.hmms_tab)
        writable: False
      - entry: $(inputs.proteins)
        writable: False
      - entry: $(inputs.workdir)
        writable: False
      - entry: $(inputs.asn_cache)
        writable: False
      - entryname: fam.mft
        entry: |
          $(inputs.hmms_tab.path)
          
#hmmsearch_wnode -lds2 LDS2 -asn-cache sequence_cache -backlog 1 -fam fam.mft -hmmsearch-path ./bin/ -cut_ga -input-jobs jobs.xml -O output

#baseCommand: /usr/bin/ltrace
#arguments: [ -oltrace.txt, hmmsearch_wnode, -backlog, "1", -cut_ga ]
baseCommand: hmmsearch_wnode
arguments: [ -backlog, "1", -cut_ga ]
inputs:
  hmm_path:
    type: Directory
  workdir: Directory
  lds2:
    type: File
    inputBinding:
      prefix: -lds2
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  proteins:
    type: File
  hmms_tab:
    type: File
  fam:
    type: string?
    default: fam.mft
    #secondaryFiles:
    #  - real_hmms.tab
    inputBinding:
      prefix: -fam
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  hmmsearch_path:
    type: string?
    default: /hmmer/bin
    inputBinding:
      prefix: -hmmsearch-path
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
outputs:
  output:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
  # strace:
  #   type: File
  #   outputBinding:
  #     glob: strace.txt
  
  
