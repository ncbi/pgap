cwlVersion: v1.0
label: kmer_build_tree
class: Workflow # task type
inputs:
    distances:
        type: File
    sort:
        type: string?
    no_merge: 
        type: boolean
    skip_markup:
        type: boolean
outputs:
    tree: File
steps:
    kmer_build_tree:
        run: ../progs/kmer_build_tree.cwl
        in:
            distances: distances
            obin: 
                default: tree_bin.asn
            otext:
                default: tree_text.asn
            sort: sort
            no_merge: no_merge
            skip_markup: skip_markup
        out: [tree]

                
            
