cwlVersion: v1.2
label: miniprot
class: CommandLineTool
baseCommand: miniprot

stdout: $(inputs.stdout_redir)
# for miniprot the order of arguments here is important:
arguments: [-S, -G, '500', -e, '500', -p, '0.01', --outs, '0.01', --outc, '0.01', -B, '0', -L, '15', -k, '5', -l, '4', -n, '2', -N, '1000',  -t, '16' ]
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
     default: miniprot_slow.paf
  # other native 
  T:
    # genetic code
    type: int?
    inputBinding:
        prefix: -T      

outputs:
  paf:
      type: stdout
