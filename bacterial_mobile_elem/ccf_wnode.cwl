cwlVersion: v1.2
label: "Execute CCF, execution"
class: CommandLineTool

baseCommand: ccf_wnode


arguments: [ -nogenbank, -ccf-wrapper-path, '/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/current/bin/', -ccf_conda_env, '/netmnt/vast01/gp/ThirdParty/CRISPRCasFinder/production/ccfenv', -ccf_root, '/netmnt/vast01/gp/ThirdParty/CRISPRCasFinder/production/CRISPRCasFinder', -levelMin, '3', -minNbSpacers, '4', -mismDRs, '15', -muscle, '/usr/local/muscle/5.3/bin/muscle',  -ncbi_scripts,  '/panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/bacterial_pipeline/system/current/bin', -spSim, '10', -truncDR, '20', -noMism ]
inputs:
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
  input_jobs:
    type: File
    inputBinding:
      prefix: -input-jobs
  output_dir:
    type: string?
    default: output
    inputBinding:
      prefix: -O
outputs:
  outdir:
    type: Directory
    outputBinding:
      glob: $(inputs.output_dir)
  
  
