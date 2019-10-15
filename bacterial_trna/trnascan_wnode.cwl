cwlVersion: v1.0
label: "Run tRNAScan, execution"
class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.asn_cache)
        writable: False

baseCommand: trnascan_wnode
arguments: [ -X, "20", -Q, -H, -b, -q, -nogenbank ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  superkingdom:
    type: int
  cove_flag_bacteria:
    type: boolean
    default: true # to cause calculation
    inputBinding:
      valueFrom: ${if (inputs.superkingdom==2)    { return true; } else {return false; } }
      prefix: -B
  cove_flag_archaea:
    type: boolean
    default: true # to cause calculation
    inputBinding:
      valueFrom: ${if (inputs.superkingdom==2157) { return true; } else {return false; } }
      prefix: -A
  gcode_othmito:
    type: string?
    inputBinding:
      prefix: -g
  binary:
    type: string?
    default: /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/ThirdParty/tRNAscan-SE/production/bin/tRNAscan-SE
    inputBinding:
      prefix: -tRNAscan
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
  taxon_db:
    type: File
    inputBinding:
        prefix: -taxon-db
        
outputs:
  # asncache:
  #   type: Directory
  #   outputBinding:
  #     glob: $(inputs.asn_cache.basename)
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
  
  
