cwlVersion: v1.0
class: CommandLineTool
baseCommand: fscr_calls_pass1
label: fscr_calls_pass1
requirements:
 - class: InlineJavascriptRequirement
 - class: InitialWorkDirRequirement
   listing:
     - entryname: input.mft
       entry: ${var blob = '# input.mft created for fscr_calls_pass1 from input input Array of Files\n'; for (var i = 0; i < inputs.input.length; i++) { blob += inputs.input[i].path + '\n'; } return blob; }

inputs:
  max_reblast_spans:
    type: int?
    inputBinding:
      prefix: '-max-reblast-spans'
  repeat_threshold:
    type: int?
    inputBinding:
      prefix: '-repeat-threshold'
  contigs:
    type: File
    inputBinding:
      prefix: '-contigs'
  input:
    type: File[] 
  input_manifest:
    type: string?
    default: input.mft
    inputBinding:
      prefix: '-input-manifest'
  asn_cache:
    type: Directory
    inputBinding:
      prefix: '-asn-cache'
  calls_name:
    type: string
    default: calls.asn
    inputBinding:
      prefix: '-o'
  reblast_locs_name:
    type: string
    default: reblast_locs.asn
    inputBinding:
      prefix: '-reblast-locs'
  masked_locs_name:
    type: string
    default: masked_locs.asn
    inputBinding:
      prefix: '-masked-locs'
    
      
outputs:  
  calls:
    type: File
    outputBinding:
      glob: $(inputs.calls_name)
  reblast_locs:
    type: File
    outputBinding:
      glob: $(inputs.reblast_locs_name)
  masked_locs:
    type: File
    outputBinding:
      glob: $(inputs.masked_locs_name)
