cwlVersion: v1.2
label: getfasta
class: CommandLineTool
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: gilist.mft
       entry: ${var blob = '# gilist.mft created for getfasta from input gilist Array of Files\n'; for (var i = 0; i < inputs.gilist.length; i++) { blob += inputs.gilist[i].path + '\n'; } return blob; }
baseCommand: getfasta
arguments: [-skip-duplicates ]
inputs:
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  gilist:
    type: File[]
  gilist_mft:
    type: string?
    default: gilist.mft
    inputBinding:
      prefix: -input-manifest
  output_name:
    type: string
    default: protein.fa
    inputBinding:
      prefix: -output
      
outputs:
  fasta:
    type: File
    outputBinding:
      glob: $(inputs.output_name)      