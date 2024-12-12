cwlVersion: v1.2
label: paf2asn
class: CommandLineTool
baseCommand: paf2asn
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: paf.mft
       entry: ${var blob = '# paf.mft created for paf2asn from input paf Array of Files\n'; for (var i = 0; i < inputs.paf.length; i++) { blob += inputs.paf[i].path + '\n'; } return blob; } 
arguments: [-partial-intron-threshold, '100', -no-scores, -pack-parts, -split-introns, -uniquify ]       
inputs:
  paf:
    type: File[]
  paf_manifest:
    type: string?
    default: paf.mft
    inputBinding:
      prefix: -input-manifest
  asn_cache:
    type: Directory[]
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
  output_name:
    type: string
    default: miniprot.asn
    inputBinding:
      prefix: -o
      

outputs:
  align:
    type: File
    outputBinding:
      glob: $(inputs.output_name)   