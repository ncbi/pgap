cwlVersion: v1.2
label: "compute_gencode"

class: Workflow
inputs:
    taxid: 
        type: int
        default: 2
    taxon_db: File
steps:
    gencode_file: 
        run: ../../compute_gencode.cwl
        in:
            taxid: taxid
            taxon_db: taxon_db
            gencode:
                default: true
        out: [output]
    superkindom_file: 
        run: ../../compute_gencode.cwl
        in:
            taxid: taxid
            taxon_db: taxon_db
            superkingdom:
                default: true
        out: [output]
    gencode_int:
        run: ../../file2int.cwl
        in:
            input: gencode_file/output
        out: [value]
    superkingdom_int:
        run: ../../file2int.cwl
        in:
            input: superkindom_file/output
        out: [value]
outputs:
    gencode: 
        type: int
        outputSource: gencode_int/value
    superkingdom: 
        type: int
        outputSource: superkingdom_int/value
    