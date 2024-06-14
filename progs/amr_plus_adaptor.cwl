cwlVersion: v1.2
label: "amr_plus_adaptor"


class: CommandLineTool
baseCommand: amr_plus_adaptor
# ~/gpipe-arch-bin/amr_plus_adaptor -organism Staphylococcus_aureus -taxid 1280 -out-organism-parameter-file out-organism-parameter-file -taxon-db taxonomy.sqlite3
inputs:
  taxon_db:
    type: File
    inputBinding:
      prefix: -taxon-db
  organism:
    type: string?
    inputBinding:
      prefix: -organism
  taxid:
    type: int
    inputBinding:
      prefix: -taxid
  out_organism_parameter_file:
    type: string 
    default: 'organism_parameter.txt'
    inputBinding:
      prefix: -out-organism-parameter-file
outputs:
  organism_parameter_in_file:
    type: File
    outputBinding:
      glob: $(inputs.out_organism_parameter_file)
