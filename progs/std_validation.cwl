cwlVersion: v1.0
label: "std_validation"

class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: ncbi/gpdev:latest
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: submit_block_template.mft
        entry: ${var blob = ''; for (var i = 0; i < inputs.submit_block_template.length; i++) { blob += inputs.submit_block_template[i].path + '\n'; } return blob; }

baseCommand: std_validation
inputs:
  annotation:
    type: File
    inputBinding:
      prefix:     -annotation
  asn_cache: # sequence_cache
    type: Directory
    inputBinding:
      prefix: -asn-cache
  exclude_asndisc_codes: # OVERLAPPING_CDS
    type: string[]
    inputBinding:
      prefix: -exclude-asndisc-codes
      itemSeparator: ","
  inent:
    type: File
    inputBinding:
      prefix:     -inent
  ingb:
    type: File
    inputBinding:
      prefix:     -ingb
  insqn:
    type: File
    inputBinding:
      prefix:     -insqn
  master_desc:
    type: File
    inputBinding:
      prefix:     -master-desc
  outdisc_name:
    type: string
    default: annot.disc
    inputBinding:
      prefix:     -outdisc
  outdiscxml_name:
    type: string
    default: annot.disc.xml
    inputBinding:
      prefix:     -outdiscxml
  outmetamaster_name:
    type: string
    default: meta.master.xml
    inputBinding:
      prefix:     -outmetamaster
  outval_name:
    type: string
    default: meta.annot.val
    inputBinding:
      prefix:     -outval
  submit_block_template:
    type: File[]
  submit_block_template_mft:
    type: File
    default: submit_block_template.mft
    inputBinding:
      prefix: -submit-block-template
  tempdir_name:
    type: Directory
    default: var
    inputBinding:
      prefix:     -tempdir
  it:
    type: boolean?
    inputBinding:
      prefix: -it
  submission_mode_genbank:
    type: boolean?
    inputBinding:
      prefix: -submission-mode-genbank
  nogenbank:
    type: boolean?
    inputBinding:
      prefix: -nogenbank
outputs:
  outdisc:
    type: File
    outputBinding:
      glob: $(inputs.outdisc_name)
  outdiscxml:
    type: File
    outputBinding:
      glob: $(inputs.outdiscxml_name)
  outmetamaster:
    type: File
    outputBinding:
      glob: $(inputs.outmetamaster_name)
  outval:
    type: File
    outputBinding:
      glob: $(inputs.outval_name)
  tempdir:
    type: File
    outputBinding:
      glob: $(inputs.tempdir_name)

  
  
