cwlVersion: v1.2
class: CommandLineTool
baseCommand: ls
requirements: 
  - class: LoadListingRequirement
    loadListing: deep_listing

inputs:
  input:
    type: Directory
    default:
      class: Directory
      location: test1
    inputBinding:
      position: 1
outputs: []
