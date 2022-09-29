#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: checkm_wnode
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      # this is needed for lds2 for proteins file to be present in the same dir as lds2 file
      - entry: $(inputs.proteins)
        writable: False
      # this is needed for input_jobs for XML file to be present in the same dir as input_jobs file
      - entry: $(inputs.seqids)
        writable: False

inputs:
  input_jobs: 
    type: File
    inputBinding:
      prefix: -input-jobs
  checkm_data_path: 
    type: Directory
    inputBinding:
      prefix: -checkm-data-path
  hmmsearch_path:
    type: string?
    default: /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/bin
    inputBinding:
      prefix: -hmmsearch-path
  pplacer_path: 
    type: string?
    default: /usr/local/pplacer/1.1a18
    inputBinding:
      prefix: -pplacer-path    
  checkm_path:
    type: string?
    default: /root/venv/bin
    inputBinding:
      prefix: -checkm-path
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
  lds2:
    type: File
    inputBinding:
      prefix: -lds2
  taxon_db:
    type: File
    inputBinding:
        prefix: -taxon-db
      
  proteins: File
  seqids: File
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
      