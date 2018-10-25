cwlVersion: v1.0 
label: "asn2fasta"

class: Workflow
hints:
inputs:
    input: File
    input_bin: File
steps:
    SPARCL: 
        run: ../../asn2fasta.cwl
        in:
            i: input_bin
            serial:
                default: binary
            type:   
                default: seq-entry
            prots_only:
                default: true
            fasta_name:
                default: proteins.fa
        out: [fasta]
    export_nucleotides: 
        run: ../../asn2fasta.cwl
        in:
            i: input
            type:   
                default: seq-entry
            nuc_fasta_name:
                default: annot.fna
        out: [nuc_fasta]
    export_proteins: 
        run: ../../asn2fasta.cwl
        in:
            i: input
            type:   
                default: seq-entry
            prot_fasta_name:
                default: annot.faa
        out: [prot_fasta]
outputs:
    SPARCL_output: 
        type: File
        outputSource: SPARCL/fasta
    export_nucleotides_output: 
        type: File
        outputSource: export_nucleotides/nuc_fasta
    export_proteins_output: 
        type: File
        outputSource: export_proteins/prot_fasta
    