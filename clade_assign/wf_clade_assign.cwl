#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

label: "Assign Clade plane complete workflow"

requirements: 
  - class: SubworkflowFeatureRequirement 
 
inputs:
  asn_cache: Directory
  CladeMarkers_asn_cache: Directory
  seqids: File
  blastdb_dir: Directory
  assembly_id: string
  ani: File
  reference_set: File

outputs:
  clade_assignment:
    type: File
    outputSource: wf_assign_clade/clade_assignment

steps:
  wf_assign_clade:
    run: wf_assign_clade.cwl
    in:
      hits: wf_find_marker_alignments/blast_align
      assembly_id: assembly_id
      asn_cache: asn_cache
      CladeMarkers_asn_cache: CladeMarkers_asn_cache
      ani: ani
      reference_set: reference_set
    out: [ clade_assignment ]
    
  wf_find_marker_alignments:
    run: wf_find_marker_alignments.cwl
    in:
      asn_cache: asn_cache
      CladeMarkers_asn_cache: CladeMarkers_asn_cache
      seqids: seqids
      blastdb_dir: blastdb_dir
    out: [blast_align]
