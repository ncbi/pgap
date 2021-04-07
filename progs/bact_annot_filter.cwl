cwlVersion: v1.2
label: "bact_annot_filter"

class: CommandLineTool
requirements:    
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: annotation.mft
        # using more than line of JS code leads to a wrong result
        entry: ${var blob = '# annotation.mft created for bact_annot_filter.mft from input input Array of Files\n'; for (var i = 0; i < inputs.input.length; i++) { blob += inputs.input[i].path + '\n'; } return blob; }
baseCommand: bact_annot_filter
inputs:
  abs_short_model_limit:
    type: int?
    inputBinding:
      prefix: -abs-short-model-limit
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  input:
    type: File[]
  input_mft:
    type: string
    default: annotation.mft
    inputBinding:
      prefix: -input-manifest
  long_model_limit:
    type: int?
    inputBinding:
      prefix: -long-model-limit
  max_overlap:
    type: int?
    inputBinding:
      prefix: -max-overlap
  max_unannotated_region:
    type: int?
    inputBinding:
      prefix: -max-unannotated-region
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  short_model_limit:
    type: int?
    inputBinding:
      prefix: -short-model-limit
  thr:
    type: File
    inputBinding:
      prefix: -thr
  out_annotation_name:
    type: string
    default: out-annotation.asn
    inputBinding:
      prefix: -o
outputs:
    out_annotation:
        type: File
        outputBinding:
            glob: $(inputs.out_annotation_name)

