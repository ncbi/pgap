cwlVersion: v1.0
label: "dumb_down_as_required"

class: CommandLineTool

baseCommand: dumb_down_as_required
inputs:
  annotation:
    type: File
    inputBinding:
      prefix: -annotation
  asn_cache: 
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  max_x_ratio:
    type: float?
    inputBinding:
      prefix: -max-x-ratio
  max_x_run:
    type: int?
    inputBinding:
      prefix: -max-x-run
  outent_name:
    type: string
    default: annot.ent
    inputBinding:
      prefix: -outent
  partial_cov_threshold:
    type: int?
    inputBinding:
      prefix: -partial-cov-threshold
  partial_len_threshold:
    type: int?
    inputBinding:
      prefix: -partial-len-threshold
  drop_partial_in_the_middle:
    type: boolean?
    inputBinding:
      prefix: -drop-partial-in-the-middle
  submission_mode_genbank:
    type: boolean?
    inputBinding:
      prefix: -submission-mode-genbank      
  submol_block_json:
        type: File?
        inputBinding:
            prefix: -submol_block_json
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  it:
    type: boolean?
    inputBinding:
      prefix: -it
outputs:
  outent: 
    type: File
    outputBinding:
      glob: $(inputs.outent_name)
