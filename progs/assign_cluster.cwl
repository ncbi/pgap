cwlVersion: v1.0 
label: "assign_cluster"

class: CommandLineTool
hints:
requirements:
    - class: InitialWorkDirRequirement
      listing:
        - entry: $(inputs.namedb_dir)
          writable: False
        - entry: $(inputs.proteins)
          writable: False
          
baseCommand: assign_cluster
inputs:
  asn_cache:
    type: Directory[]?
    inputBinding:
      prefix: -asn-cache
      itemSeparator: ","
      # default: ${GP_cache_dir},${GP_HOME}/third-party/data/BacterialPipeline/uniColl/ver-3.2/cache
  comp_based_stats:
    type: string?
    inputBinding:
      prefix: -comp_based_stats
      # default: F
  cutoff:
    type: float?
    inputBinding:
      prefix: -cutoff
  hfmt:
    type: string?
    inputBinding:
      prefix: -hfmt
  hits:
    type: File
    inputBinding:
      prefix: -hits
  margin:
    type: float?
    inputBinding:
      prefix: -margin
  namedb_dir:
    type: Directory?
  namedb:
    type: string?
    inputBinding:
      prefix: -namedb
      valueFrom: $(inputs.namedb_dir.path)/$(inputs.namedb)
  nogenbank:
    type: boolean
    inputBinding:
      prefix: -nogenbank
  seg:
    type: string?
    inputBinding:
      prefix: -seg
  sure_cutoff:
    type: float?
    inputBinding:
      prefix: -sure-cutoff
  task:
    type: string?
    inputBinding:
      prefix: -task
  threshold:
    type: int?
    inputBinding:
      prefix: -threshold
  unicoll_sqlite:
    type: File
    inputBinding:
      prefix: -unicoll_sqlite
  word_size:
    type: int?
    inputBinding:
      prefix: -word_size
  xml_name:
    type: string?
    default: protein_assignments.xml
    inputBinding:
      prefix: -o
  lds2:
    type: File?
    inputBinding:
      prefix: -lds2
  proteins:
    type: File?
  
    
outputs:
  protein_assignments:
    type: File
    outputBinding:
      glob: $(inputs.xml_name)
    