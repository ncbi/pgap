cwlVersion: v1.2
label: "align_filter"

class: CommandLineTool
    
baseCommand: align_filter
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
     - entryname: aligns.mft
       entry: ${var blob = '# aligns.mft created for align_filter from input "input" Array of Files\n'; for (var i = 0; i < inputs.input.length; i++) { blob += inputs.input[i].path + '\n'; } return blob; }
     - entryname: compartments.mft
       entry: |
          ${
            var blob = '# compartments.mft created for align_filter from input "compartments" Array of Files\n';
            if (inputs.compartments) {  
              for (var i = 0; i < inputs.compartments.length; i++) {
                blob += inputs.compartments[i].path + '\n';
              }
            }
            return blob;
          }
     - entryname: subject_allowlist.mft
       entry: ${var blob = '# subject_allowlist.mft created for align_filter from input "subject_allowlist" File\n'; if ( inputs.subject_allowlist == null) { return blob; } else { blob += inputs.subject_allowlist.path + '\n';  return blob; }}

inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  filter:
    type: string?
    inputBinding:
      prefix: -filter
  ifmt:
    type: string?
    inputBinding:
      prefix: -ifmt
  input:
    type: File[]
  input_mft:
    type: string?
    default: aligns.mft
    inputBinding:
      prefix: -input-manifest
  compartments:
    type: File[]?
  compartments_mft:
    type: string?
    default: compartments.mft
    inputBinding:
      prefix: -compartments-manifest
  nogenbank:
    type: boolean
    default: true
    inputBinding:
      prefix: -nogenbank
  subject_allowlist: 
    type: File?
  subject_allowlist_mft:
    type: string?
    default: subject_allowlist.mft
    inputBinding:
      prefix: -subject-allowlist
  onon_match_name: 
    type: string
    default: align-nomatch.asn
    inputBinding:
        prefix:  -non-match-output

  o_name: 
    type: string
    default: align.asn
    inputBinding:
        prefix:  -o
outputs:
   o:
        type: File
        outputBinding:
            glob: $(inputs.o_name)
   onon_match:
        type: File
        outputBinding:
            glob: $(inputs.onon_match_name)
