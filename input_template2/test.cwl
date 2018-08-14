cwlVersion: v1.0 
label: "cat"
class: ExpressionTool
expression: $(inputs.topology)
inputs:
    topology:
      type:
        type: enum
        name: topology
        symbols:
            - circular
            - linear
    fasta: 
        type: File
    organism:
        type:
            name: organism
            type: record
            fields:
                scientific_name: string
                taxon: int
                strain: string
    contact_info:
        type:
            name: contact_info
            type: record
            fields:
                last_name: string
                first_name: string
                email: string
                organization: string
                department: string
                phone: string
                street: string
                city: string
                postal_code: string
                country: string
        
    authors:
        type: 
            type: array
            items: 
                  type: record
                  name: author
                  fields:
                      first_name: string
                      last_name: string
                      middle_initial: string?
    bioproject: string
    biosample: string
    locus_tag_prefix: string
    publcations:
        type:
            type: array
            items:
                type: record
                name: publication
                fields:
                  title: string
                  status: 
                    type:
                        type: enum
                        name: status
                        symbols:
                            - 'unpublished'
                            - 'in-press'
                            - 'published'
                  authors:
                    type:
                        type: array
                        items:
                            type: record
                            name: author
                            fields:
                              first_name: string
                              last_name: string
                              middle_initial: string?
outputs:
    ok: boolean



