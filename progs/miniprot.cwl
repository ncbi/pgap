cwlVersion: v1.2
label: miniprot
class: CommandLineTool
baseCommand: miniprot

stdout: $(inputs.stdout_redir)
inputs:
  genome:
    type: File 
    inputBinding:
      position: 1
  proteins:
    type: File 
    inputBinding:
      position: 2
  miniprot_params: 
    type: string
    inputBinding:
      prefix: -miniprot-params
  cpu_count:
    type: int
    inputBinding:
      prefix: -t
  stdout_redir:
     type: string?
     default: stdout
      

outputs:
  paf:
      type: stdout
