cwlVersion: v1.2
label: "map_amr_ids"

class: CommandLineTool
baseCommand: map_amr_ids
requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    ramMax: 3000
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.report)
        writable: False



inputs:
  report:
    type: File
    inputBinding:
      prefix: -input
  gencoll_id:
    type: int
    inputBinding:
      prefix: -gencoll-id
  dryrun:
    type: boolean?
    inputBinding:
      prefix: -dryrun      
  load_to_database:
    type: boolean?
    inputBinding:
      prefix: -load-to-database
  report_outname:
    type: string
    inputBinding:
      prefix: -o      
outputs:
  report:
    type: File
    outputBinding:
      outputEval: |
        ${
          var newoutput = new File(inputs.outname);
          if(newoutput.exists()) {
            return newoutput;
          }
          else {
            return inputs.report;
          }
        }
