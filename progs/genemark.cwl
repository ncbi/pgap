cwlVersion: v1.0 
label: "genemark"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
        - class: InitialWorkDirRequirement
          listing:
            - entryname: annotation.mft
              entry: $(inputs.annotation.path)
            - entryname: sequences.mft
              entry: $(inputs.sequences.path)
            - entryname: alignments.mft
              entry: $(inputs.alignments.path)
          
baseCommand: genemark
inputs:
  alignments:
    type: File
  alignments_manifest:
    type: string
    default: alignments.mft
    inputBinding:
      prefix: -alignments
  annotation:
    type: File
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
  hmm_params:
    type: File
    inputBinding:
      prefix: -hmm-params
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
