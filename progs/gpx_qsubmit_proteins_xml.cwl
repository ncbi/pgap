cwlVersion: v1.2
label: "gpx_qsubmit"
doc: >
    This workflow is specialized for the simple case of XML input that just need a little bit of massaging.
    
    We need to have a flavored file because gpx_qsubmit reacts on the presence of a particular form of input instead
    of relying on a presence of actual non-empty container of objects
class: CommandLineTool
baseCommand: gpx_qsubmit
inputs:
  xml_jobs:
    type: File?
    inputBinding:
      prefix: -xml-jobs
  output_xml_jobs:
    type: string
    default: jobs.xml
    inputBinding:
      prefix: -o
  
      
outputs:
  jobs:
    type: File
    outputBinding:
      glob: $(inputs.output_xml_jobs)    
  
