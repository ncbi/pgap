cwlVersion: v1.0
label: "Set operations on sets of lines"
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: A.mft
        # using more than line of JS code leads to a wrong result
        entry: ${var blob = ''; for (var i = 0; i < inputs.A.length; i++) { blob += inputs.A[i].path + '\n'; } return blob; }
      - entryname: B.mft
        # using more than line of JS code leads to a wrong result
        entry: ${var blob = ''; for (var i = 0; i < inputs.B.length; i++) { blob += inputs.B[i].path + '\n'; } return blob; }

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
