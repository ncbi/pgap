cwlVersion: v1.0 
label: "add_prot_names_to_annot"

class: CommandLineTool
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: proteins.mft
       entry: ${var blob = '# proteins.mft created for add_prot_names_to_annot from input proteins Array of Files\n'; for (var i = 0; i < inputs.proteins.length; i++) { blob += inputs.proteins[i].path + '\n'; } return blob; }

baseCommand: add_prot_names_to_annot
inputs:
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  defline_cleanup_rules:
    type: File
    inputBinding:
      prefix: -defline-cleanup-rules
  input:
    type: File
    inputBinding:
      prefix: -input
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
  proteins:
    type: File[]
  proteins_mft:
    type: string?
    default: proteins.mft
    inputBinding:
      prefix: -proteins
  submission_mode_genbank:
    type: boolean?
    inputBinding:
      prefix: -submission-mode-genbank
  unicoll_sqlite:
    type: File
    inputBinding:
      prefix: -unicoll_sqlite
  out_annotation_name:
    type: string
    default: annotation.asn
    inputBinding:
      prefix: -o
outputs:
    out_annotation:
        type: File
        outputBinding:
            glob: $(inputs.out_annotation_name)

