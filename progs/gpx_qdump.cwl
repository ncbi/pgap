cwlVersion: v1.0 
label: "gpx_qdump"

class: CommandLineTool
hints:
# requirements:
  # - class: InlineJavascriptRequirement
  # - class: InitialWorkDirRequirement
    # listing:
      # - entry:  $(inputs.lds2)
        # writable: True

baseCommand: gpx_qdump
inputs:
  input_path:
    type: Directory
    inputBinding:
      prefix: -input-path
  output_name:
    type: string?
    default: output.asn
    inputBinding:
      prefix: -output
  # lds2: File?
  unzip:
    type: string?
    inputBinding:
      prefix: -unzip
outputs:
  # blast_align: This needs to be more generic, lots of wnodes call this
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
