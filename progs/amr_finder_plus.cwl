cwlVersion: v1.2
label: "amr_finder_plus"

class: CommandLineTool
baseCommand: amrfinder
inputs:
  nucleotide:
    type: File
    inputBinding:
      prefix: --nucleotide
  database:
    type: Directory
    inputBinding:
      prefix: --database
  threads: 
    type: int
    default: 1
    inputBinding:
      prefix: --threads
  output_name:
    type: string
    default: 'output.tsv'
    inputBinding:
      prefix: --output
  plus:
    type: boolean?
    inputBinding:
      prefix: --plus
  gpipe_org:
    type: boolean?
    inputBinding:
      prefix: --gpipe_org
  pgap:
    type: boolean?
    inputBinding:
      prefix: --pgap
  organism:
    type: string?
    inputBinding:
      prefix: --organism
outputs:
  report:
    type: File
    outputBinding:
      glob: $(inputs.output_name)
