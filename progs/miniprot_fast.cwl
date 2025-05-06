cwlVersion: v1.2
label: miniprot
class: CommandLineTool
baseCommand: miniprot

stdout: $(inputs.stdout_redir)
# for miniprot the order of arguments here is important:
arguments: [ -p, '0.01', --outs, '0.01', --outc, '0.01', -S, -L, '15', -n, '2', -N, '1000', -t, '16' ]
inputs:
  genome:
    type: File 
    inputBinding:
      position: 1
  proteins:
    type: File 
    inputBinding:
      position: 2
  stdout_redir:
     type: string?
     default: miniprot_fast.paf
  # other native 
  T:
    # genetic code
    type: int?
    inputBinding:
        prefix: -T      

outputs:
  paf:
      type: stdout
