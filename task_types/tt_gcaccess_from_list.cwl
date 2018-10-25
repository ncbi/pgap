cwlVersion: v1.0
label: "gcaccess_from_list"
# File: task+types/tt_gcaccess_from_list.cwl
class: Workflow # task type
hints:
inputs:
  gc_id_list: File
outputs:
  gencoll_asn:
    type: File
    outputSource: gc_get_assembly/gencoll_asn
steps:
  gc_get_assembly:
    run: ../progs/gc_get_assembly.cwl
    in:
      mode: 
        default: AllSequences
      release_id: gc_id_list
    out: [gencoll_asn]
# this is for the future  we might need this in general case    
#  gc_get_molecules:
#    run: ../progs/gc_get_molecules.cwl
#    in:
#      filter: 
#        default: all
#      gc_assembly: gc_get_assembly/output
#      level: 
#        default: top-level
#    out: [gencoll_asn]
