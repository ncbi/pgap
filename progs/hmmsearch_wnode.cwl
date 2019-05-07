cwlVersion: v1.0
label: "hmmsearch_wnode"

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.hmm_path)
        writable: False
      #- entry: $(inputs.hmms_tab)
      #  writable: False
      - entry: $(inputs.proteins)
        writable: False
      - entry: $(inputs.workdir)
        writable: False
      - entry: $(inputs.asn_cache)
        writable: False
      - entryname: fam.mft
        entry: ${ var blob = '# fam.mft created for hmmsearch_wnode from input hmms_tab File\n'; if ( inputs.hmms_tab == null ) { return blob; }  else { return blob + inputs.hmms_tab.path; } }
          
#hmmsearch_wnode -lds2 LDS2 -asn-cache sequence_cache -backlog 1 -fam fam.mft -hmmsearch-path ./bin/ -cut_ga -input-jobs jobs.xml -O output
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
    type: File?
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
    default: /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/bin
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
  
  
