cwlVersion: v1.0 
label: "prepare_sparclbl_input"

class: CommandLineTool
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: other_assignments.mft
       entry: ${var blob = ''; for (var i = 0; i < inputs.other_assignments.length; i++) { blob += inputs.other_assignments[i].path + '\n'; } return blob; }

baseCommand: prepare_sparclbl_input
inputs:
  input: 
    type: File
    inputBinding:
        prefix: -input
  other_assignments: 
    type: File[]
  other_assignments_mft:
    type: string?
    default: other_assignments.mft
    inputBinding:
        prefix: -other-assignments
        
  precedence_filename:
    type: string?
    default: precedences.tsv
    inputBinding:
        prefix: -precedences
  prot_ids_filename:
    type: string?
    default: prot.seq_ids
    inputBinding:
        prefix:  -o
  unicoll_sqlite: 
    type: File
    inputBinding:
        prefix: -unicoll_sqlite
outputs:
    precedences:
        type: File
        outputBinding:
            glob: $(inputs.precedence_filename)
    prot_ids:
        type: File
        outputBinding:
            glob: $(inputs.prot_ids_filename)
    