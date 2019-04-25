cwlVersion: v1.0 
label: "genemark_training"

class: CommandLineTool
requirements:
    - class: InlineJavascriptRequirement
    - class: InitialWorkDirRequirement
      listing:
        - entryname: annotation.mft
          entry: ${ var blob = '# annotation.mft created for genemark_training from input annotation File\n'; if ( inputs.annotation == null ) { return blob; } else { return blob + inputs.annotation.path; } }
        - entryname: sequences.mft
          entry: ${ var blob = '# sequences.mft created for genemark_training from input sequences File\n'; if ( inputs.sequences == null) { return blob; }  else { return blob + inputs.sequences.path; } }
        - entryname: alignments.mft
          entry: ${ var blob = '# alignments.mft created for genemark_training from input alignments File\n'; if ( inputs.alignments == null ) { return blob; }  else { return blob + inputs.alignments.path; } }
          
baseCommand: genemark
inputs:
  alignments:
    type: File?
  alignments_manifest:
    type: string
    default: alignments.mft
    inputBinding:
      prefix: -alignments
  annotation:
    type: File?
  annotation_manifest:
    type: string
    default: annotation.mft
    inputBinding:
      prefix: -annotation
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  genemark_path:
    type: Directory
    inputBinding:
      prefix: -genemark-path
  out_hmm_params_name:
    type: string
    # this is hardcoded
    default: GeneMark_hmm_combined.mod
  min_seq_len:
    type: int?
    inputBinding:
      prefix: -min_seq_len
  marked_annotation_name:
    type: string?
    default: marked-annotation.asn
    inputBinding:
      prefix: -marked-annotation
  preliminary_models_name: 
    type: string?
    default: preliminary-models.asn
    inputBinding:
      prefix: -out
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  sequences:
    type: File
  sequences_manifests:
    type: string
    default: sequences.mft
    inputBinding:
      prefix: -sequences
  thr:
    type: File
    inputBinding:
      prefix: -thr
  tmp:
    type: string
    default: .
    inputBinding:
      prefix: -tmp
outputs:
    marked_annotation:
        type: File
        outputBinding:
            glob: $(inputs.marked_annotation_name)
    preliminary_models:
        type: File
        outputBinding:
            glob: $(inputs.preliminary_models_name)
    out_hmm_params:
        type: File
        outputBinding:
            glob: $(inputs.tmp)/$(inputs.out_hmm_params_name)

