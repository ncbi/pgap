cwlVersion: v1.2
label: "asn2flat"

class: CommandLineTool

baseCommand: asn2gaf

inputs:
  input:
    type: File
    inputBinding:
      prefix: -input

  oname:
    type: string
    default: annot.gaf
    inputBinding:
      prefix: -output

  taxid:
    type: int
    inputBinding:
      prefix: -taxid

  go_hierarchy:
    type: File
    default:
      class: File
      path: /netmnt/vast01/gp/ThirdParty/ExternalData/GeneOntology/production/data/ontology/go-basic.obo
    inputBinding:
      prefix: -go-hierarchy

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.oname)

