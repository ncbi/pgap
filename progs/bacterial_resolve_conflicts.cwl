cwlVersion: v1.0 
label: "bacterial_resolve_conflicts"

class: CommandLineTool
requirements:    
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: features.mft
        entry: ${var blob = '# features.mft created for bacterial_resolve_conflicts from input features Array of Files\n'; if ( ! inputs.hasOwnProperty('features') ) { return blob; }; for (var i = 0; i < inputs.features.length; i++) { blob += inputs.features[i].path + '\n'; } return blob; }
      - entryname: prot.mft
        entry: ${var blob = '# prot.mft created for bacterial_resolve_conflicts from input prots Array of Files\n'; if ( ! inputs.hasOwnProperty('prots') ) { return blob; }; for (var i = 0; i < inputs.prots.length; i++) { blob += inputs.prots[i].path + '\n'; } return blob; }
baseCommand: bacterial_resolve_conflicts
inputs:
    features: # all external to this node
        type: File[]
    features_mft:
        type: string
        default: features.mft
        inputBinding:
          prefix: -features
    input_annotation: # mft not used
        type: File[]?
    prot: # mft not used
        type: File[]?
    prot_mft:
        type: string
        default: prot.mft
        inputBinding:
          prefix: -prot
    mapped_regions: # mft not used -mapped-regions
        type: File[]?
    thr: 
        type: File
        inputBinding:
          prefix: -thr
    asn_cache: 
        type: Directory[]
        inputBinding:
          prefix: -asn-cache
          itemSeparator: ","
    accept_align_name:
        type: string
        default: accept-align.asn
        inputBinding:
          prefix: -accept-align
    out_annotation_name:
        type: string
        default: accept.asn 
        inputBinding:
          prefix: -accept
    review_name:
        type: string
        default: review.asn 
        inputBinding:
          prefix: -review
outputs:
    protein_aligns:
        type: File
        outputBinding:
            glob: $(inputs.accept_align_name)
    review:
        type: File
        outputBinding:
            glob: $(inputs.review_name)
    annotation: 
        type: File
        outputBinding:
            glob: $(inputs.out_annotation_name)
