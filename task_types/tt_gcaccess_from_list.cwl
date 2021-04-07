cwlVersion: v1.2
label: "gcaccess_from_list"
# File: task+types/tt_gcaccess_from_list.cwl
class: Workflow # task type
inputs:
  gc_id_list: File
  gc_cache: File
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
      release_id_list: gc_id_list
      gc_cache: gc_cache
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
