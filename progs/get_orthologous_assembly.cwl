cwlVersion: v1.2
label: "get_orthologous_assembly"

class: CommandLineTool
baseCommand: get_orthologous_assembly
inputs:
  unicoll_sqlite: 
    type: File
    inputBinding:
      prefix: -unicoll_sqlite
  taxon_db: 
    type: File
    inputBinding:
      prefix: -taxon-db
  taxid: 
    type: int
    inputBinding:
      prefix: -taxid
  output_name: 
    type: string?
    default: orthologous.assembly.gcid
    inputBinding:
      prefix: -output
    
outputs: 
  output:
    type: File
    outputBinding: 
      glob: $(inputs.output_name)  
  
