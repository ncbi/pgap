cwlVersion: v1.0 
label: "bact_entries_merge"
class: CommandLineTool
baseCommand: bact_entries_merge
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
        - entryname: annotation.mft
          entry:  ${var blob = '# annotation.mft created for bact_entries_merge from input annotation Array of Files\n';for (var i = 0; i < inputs.annotation.length; i++) {blob += inputs.annotation[i].path  + '\n';}return blob;}
        - entryname: ab_initio.mft
          entry:  ${var blob = '# ab_initio.mft created for bact_entries_merge from input ab_initio Array of Files\n';for (var i = 0; i < inputs.ab_initio.length; i++) {blob += inputs.ab_initio[i].path  + '\n';}return blob;}
        
inputs:
  annotation:
    type: File[]
  ab_initio:
    type: File[]
  annotation_mft:
    type: string?
    default: annotation.mft
    inputBinding:
      prefix: -input-manifest
  ab_initio_mft:
    type: string?
    default: ab_initio.mft
    inputBinding:
      prefix: -ab_initio-manifest
  output_name:
    type: string?
    default: models.asn
    inputBinding:
      prefix: -o

    
outputs:
  out_annotation:
    type: File
    outputBinding:
      glob: $(inputs.output_name)


