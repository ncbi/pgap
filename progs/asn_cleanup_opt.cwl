cwlVersion: v1.0
label: "asn_cleanup_opt"
class: CommandLineTool
baseCommand: asn_cleanup
requirements:
    - class: InlineJavascriptRequirement
    - class: InitialWorkDirRequirement
      listing:
        - entryname: real_or_empty.asn
          entry: ${ if ( inputs.inp_annotation == null ) { return ''; } else { return inputs.inp_annotation.content; } }
inputs:
  inp_annotation:
    type: File?
    inputBinding:
        loadContents: true
  hidden_inp_annotation:
    type: string
    default: real_or_empty.asn
    inputBinding:
      prefix: -i
  out_annotation_name:
    type: string
    default: cleaned-annotation.asn
    inputBinding:
      prefix: -o
  serial: 
    type: string?
    default: binary
    inputBinding:
      prefix: -serial 
  type1: 
    type: string?
    default: seq-entry
    inputBinding:
      prefix: -type
  outformat:
    type: string?
    default: 'text' 
    inputBinding:
      prefix: -outformat

outputs:
  annotation:
    type: File?
    outputBinding:
      glob: $(inputs.out_annotation_name)
      loadContents: true
      outputEval: ${ if ( inputs.annotation.content.length() ==0  ) { return null; } else { return inputs.annotation; } }

  
  
