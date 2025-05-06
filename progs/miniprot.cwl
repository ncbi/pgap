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
  cpu_count:
    type: int
    inputBinding:
      prefix: -t
  stdout_redir:
     type: string?
     default: miniprot.paf
  # other native 
  T:
    # genetic code
    type: int?
    inputBinding:
        prefix: -T
  outs:
    type: float?
    inputBinding:
        prefix: --outs
  outc:
    type: float?
    inputBinding:
        prefix: --outc
  S:
    type: boolean?
    inputBinding:
        prefix: -S
  G:
    type: int?
    inputBinding:
        prefix: -G
  L:
    type: int?
    inputBinding:
        prefix: -L
  N:
    type: int?
    inputBinding:
        prefix: -N
  B:
    type: int?
    inputBinding:
        prefix: -B

  n:
    type: int?
    inputBinding:
        prefix: -n
  p:
    type: float?
    inputBinding:
        prefix: -p
  e:
    type: int?
    inputBinding:
        prefix: -e
  k:
    type: int?
    inputBinding:
        prefix: -k
  l:
    type: int?
    inputBinding:
        prefix: -l
  
      

outputs:
  paf:
      type: stdout
