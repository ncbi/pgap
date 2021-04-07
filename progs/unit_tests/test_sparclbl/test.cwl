#!/usr/bin/env cwl-runner
label: "Test sparclbl"
cwlVersion: v1.2
class: Workflow

requirements:
  - class: ScatterFeatureRequirement        

inputs:
  s: File
  p: File
  b: Directory
  d: Directory
steps:
  test:
    run: ../../sparclbl.cwl
    in:
      s: s # ${work}/protein.fa 
      p: p # ${input.precedences.target}
      b: b # ${GP_HOME}/third-party/data/CDD/cdd 
      d: d # ${GP_HOME}/third-party/data/cdd_add 
        
      m: 
        default: 20
      n: 
        default: 500
      x: 
        default: 1
    out: [protein_assignments]

    
outputs:
  protein_assignments:
    type: File
    outputSource: test/protein_assignments
    
  
  
