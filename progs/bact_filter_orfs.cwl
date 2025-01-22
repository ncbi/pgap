cwlVersion: v1.2
label: bact_filter_orfs
class: CommandLineTool
baseCommand: bact_filter_orfs
arguments: ['-long-orf-thresh', '450', '-include-uncovered-regions', '-include-overlap-regions']
inputs:
  asn_cache:
    # '${GP_cache_dir}'
    type: Directory
    inputBinding:
      prefix: -asn-cache
  models:
    type: File
    inputBinding:
      prefix: -models
  orfs:
    type: File
    inputBinding:
      prefix: -orfs
  output_accept:
    type: string?
    inputBinding:
      prefix: -oaccept
    default: accept_orfs.asn
  output_reject:
    type: string?
    inputBinding:
      prefix: -oreject
    default: reject_orfs.asn
  output_report:
    type: string?
    inputBinding:
      prefix: -oreport
    default: report.tsv


outputs:
  accept:
    type: File
    outputBinding:
      glob: $(inputs.output_accept)  
  reject:
    type: File?
    outputBinding:
      glob: $(inputs.output_reject)  
  report:
    type: File?
    outputBinding:
      glob: $(inputs.output_report) 
