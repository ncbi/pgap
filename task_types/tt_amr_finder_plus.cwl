#!/usr/bin/env cwl-runner
cwlVersion: v1.2
label: "amr_finder_plus"
class: Workflow

inputs:
  gff: File
  nucleotides: File
  proteins: File
  database: Directory
  # used by an_amr_plus as build.org.taxid, we need to pass this from the very top
  taxid: int 
  organism: string 
  taxon_db: File
  
outputs: 
  report:
    type: File
    outputSource:
      proper_application_step/report
steps:
  action_node_equivalent:
    run: ../progs/amr_plus_adaptor.cwl
    in:
      organism: organism
      taxid: taxid
      taxon_db: taxon_db
    out: [organism_parameter_in_file]
  # example of passing things from step action_node_equivalent
  organism_parameter:
    run: ../progs/file2string.cwl
    in: 
      input: action_node_equivalent/organism_parameter_in_file
    out: [value]
  
  proper_application_step:
    run: ../progs/amr_finder_plus.cwl
    in: 
      proteins: proteins
      gff: gff
      nucleotide: nucleotides
      organism: organism_parameter/value
      
      database: database
      plus: 
        default: true
      gpipe_org:
        default: true
      pgap:
        default: true
    out: [report]


