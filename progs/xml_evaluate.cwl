cwlVersion: v1.0
label: xml_evaluate
class: CommandLineTool
baseCommand: xml_evaluate
inputs:            
        
  input:
     type: File?
     inputBinding:
        prefix: -input
  input_manifest:
     type: File?
     inputBinding:
        prefix: -input-manifest
  input_mask:
     type: string?
     inputBinding:
        prefix: -input-mask
  input_path:
     type: string?
     inputBinding:
        prefix: -input-path
  
  xpath_fail:
     type: string?
     inputBinding:
        prefix: -xpath-fail
  xpath_success:
     type: string?
     inputBinding:
        prefix: -xpath-success
  
  xslt:
     type: File?
     inputBinding:
        prefix: -xslt
  xslt_manifest:
     type: File?
     inputBinding:
        prefix: -xslt-manifest
  xslt_mask:
     type: string?
     inputBinding:
        prefix: -xslt-mask
  xslt_path:
     type: string?
     inputBinding:
        prefix: -xslt-path

  xml_output_output:
     type: string?
     inputBinding:
        prefix: -xml-output
        
  conffile:
     type: File?
     inputBinding:
        prefix: -conffile
  logfile_output:
     type: string?
     inputBinding:
        prefix: -logfile
outputs:
  xml_output:
      type: File?
      outputBinding:
          glob: $(inputs.xml_output_output)

  logfile:
      type: File?
      outputBinding:
          glob: $(inputs.logfile_output)
  success:
        type: boolean
        outputBinding:
            outputEval: $(true)