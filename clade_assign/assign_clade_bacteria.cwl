#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

label: "Assign Clade, assign_clade_bacteria"

hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest

baseCommand: assign_clade_bacteria
arguments: [ -comp_based_stats, "F", -lower-threshold, "0.004", -matrix, BLOSUM80, -min-markers, "17", -release-id, "0",  -seg, "22 2.2 2.5", -soft_masking, "true", -task, tblastn, -threshold, "18", -upper-threshold, "0.01", -word_size, "6", -nogenbank ]

inputs:
  conffile:
    type: File?
    default:
      class: File
      location: /panfs/pan1.be-md.ncbi.nlm.nih.gov/gpipe/etc/bact/ncbi.ini
    inputBinding:
      prefix: -conffile
  assembly_id:
    type: string
    inputBinding:
      prefix: -assembly-taxid
  sorted_aligns:
    type: File
    inputBinding:
      prefix: -hits 
  asn_cache:
    type: Directory
    inputBinding:
      prefix: -asn-cache
      valueFrom: $(inputs.asn_cache.basename),$(inputs.CladeMarkers_asn_cache.basename)
  CladeMarkers_asn_cache:
    type: Directory
  ani:
    type: File
    inputBinding:
      prefix: -ani 
#  clade_tree:
#    type: File
#      inputBinding:
#      prefix: -clade-tree 
  clade_tree_manifest:
    type: File?
    default:
      class: File
      location: ../input/dummy.mft
    inputBinding:
      prefix: -clade-tree-manifest
  reference_set:
    type: File
    inputBinding:
      prefix: -reference-set
  output:
    type: string?
    default: clade_assignment.xml
    inputBinding:
      prefix: -o

outputs: 
  clade_assignment:
    type: File
    outputBinding:
      glob: $(inputs.output)

