cwlVersion: v1.0 
label: "sparclbl"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
baseCommand: sparclbl.sh
inputs:
  s: 
    type: File? # to accomodate output of asn2fasta which is of type [null, File]
    inputBinding:
        prefix: -s
  p: 
    type: File
    inputBinding:
        prefix: -p
  m: 
    type: int?
    inputBinding:
        prefix: -m
  n: 
    type: int?
    inputBinding:
        prefix: -n
  b: 
    type: Directory
  d: 
    type: Directory
    inputBinding:
        prefix: -d
  blastdb:
    type: string
    default: cdd
    inputBinding:
        prefix: -b
        valueFrom: $(inputs.b.path)/$(inputs.blastdb)
  x: 
    type: int
    inputBinding:
        prefix: -x
  protein_assignments_name:
    type: string?
    default: proteins.xml
    inputBinding:
        prefix: -o
        
outputs:
    protein_assignments:
        type: File
        outputBinding:
            glob: $(inputs.protein_assignments_name)

    
