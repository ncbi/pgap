cwlVersion: v1.2
label: seq_filter
class: CommandLineTool
baseCommand: seq_filter
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: seqids.mft
       entry: ${var blob = '# seqids.mft created for seq_filter from input seqids Array of Files\n'; for (var i = 0; i < inputs.seqids.length; i++) { blob += inputs.seqids[i].path + '\n'; } return blob; }
       
arguments: [-filter, 'length < 30' ]
inputs:
  seqids:
    type: File[]
  seqids_mft:
    type: string?
    default: seqids.mft
    inputBinding:
      prefix: -input

  match_name:
    type: string?
    default: match       
    inputBinding:
      prefix: -match
  nomatch_name:
    type: string?
    default: no-match          
    inputBinding:
      prefix: -output-nomatch 
      
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","

outputs:
  match:
    type: File
    outputBinding:
      glob: $(inputs.match_name)      
  nomatch:
    type: File
    outputBinding:
      glob: $(inputs.nomatch_name)       
