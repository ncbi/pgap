cwlVersion: v1.0 
label: "compute_gencode"

class: Workflow
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
inputs:
    taxid: 
        type: int
        default: 2
    taxon_db: File
steps:
    gencode: 
        run: ../../compute_gencode.cwl
        in:
            taxid: taxid
            taxon_db: taxon_db
            gencode:
                default: true
        out: [output]
    superkindom: 
        run: ../../compute_gencode.cwl
        in:
            taxid: taxid
            taxon_db: taxon_db
            superkindom:
                default: true
        out: [output]
    gencode_int:
        run: ../../file2int.cwl
        in:
            input: gencode/output
        out: [value]
    superkingdom_int:
        run: ../../file2int.cwl
        in:
            input: superkingdom/output
        out: [value]
outputs:
    gencode: 
        type: int
        outputSource: gencode_int/value
    superkingdom: 
        type: int
        outputSource: superkingdom_int/value
    