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
    app: 
        run: ../../compute_gencode.cwl
        in:
            taxid: taxid
            taxon_db: taxon_db
        out: [output]
    conversion:
        run: ../../file2int.cwl
        in:
            input: app/output
        out: [value]
outputs:
    gencode: 
        type: int
        outputSource: conversion/value
    