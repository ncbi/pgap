cwlVersion: v1.0
label: "val_format"

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

baseCommand: set_operation
inputs:
  operation:
    type: string
    inputBinding:
      prefix: -operation
  A:
    type: File[]
  A_impl:
    type: string
    default: A.mft
    inputBinding:
      prefix: -A-manifest
  B:
    type: File[]
  B_impl:
    type: string
    default: B.mft
    inputBinding:
      prefix: -B-manifest
  output_impl:
    type: string
    default: result.lst
    inputBinding:
      prefix: -output
outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.output_impl)

  
  
