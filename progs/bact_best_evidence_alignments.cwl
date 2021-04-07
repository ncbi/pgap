cwlVersion: v1.2
label: "bact_best_evidence_alignments"

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: align.mft
        entry: ${var blob = '# align.mft created for bact_best_evidence_alignments from input align Array of Files\n'; for (var i = 0; i < inputs.align.length; i++) { blob += inputs.align[i].path + '\n'; } return blob; }
      - entryname: annotation.mft
        entry: ${var blob = '# annotation.mft created for bact_best_evidence_alignments from input annotation Array of Files\n'; for (var i = 0; i < inputs.annotation.length; i++) { blob += inputs.annotation[i].path + '\n'; } return blob; }

baseCommand: bact_best_evidence_alignments
arguments: [-support-threshold, "25.0"]
inputs:
  annotation:
    type: File[]
  annotation_manifest:
    type: string
    default: annotation.mft
    inputBinding:
      prefix: -annotation
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  align:
    type: File[]
  input_manifest: 
    type: string
    default: align.mft
    inputBinding:
      prefix: -input-manifest
  max_overlap:
    type: int?
    inputBinding:
      prefix: -max-overlap
  output_align_name:
    type: string
    default: best_aligns.asn
    inputBinding:
      prefix: -o
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  start_stop_allowance:
    type: int?
    inputBinding:
      prefix: -start-stop-allowance
  thr:
    type: File
    inputBinding:
      prefix: -thr
  unicoll_sqlite:
    type: File
    inputBinding:
      prefix: -unicoll_sqlite
outputs:
  out_align:
    type: File
    outputBinding:
        glob: $(inputs.output_align_name)

