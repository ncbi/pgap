cwlVersion: v1.2
label: "std_validation"

class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: submit_block_template.mft
        entry: ${var blob = '# submit_block_template.mft created for std_validation from input submit_block_template Array of Files\n'; for (var i = 0; i < inputs.submit_block_template.length; i++) { blob += inputs.submit_block_template[i].path + '\n'; } return blob; }
      - entryname: master_desc_mft.mft
        entry: ${var blob = '# master_desc_mft.mft created for std_validation from input master_desc Array of Files\n'; for (var i = 0; i < inputs.master_desc.length; i++) { blob += inputs.master_desc[i].path + '\n'; } return blob; }
        

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
    type: string
    default: submit_block_template.mft
    inputBinding:
      prefix: -submit-block-template
  master_desc:
    type: File[]
  master_desc_mft:
    type: string
    default: master_desc_mft.mft
    inputBinding:
      prefix:     -master-desc-manifest
  tempdir_name:
    type: string
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
  # this is a standard gpipe parameter
  # we are passing it to called applications (asnvalidate, etc) as tmpdir
  # we do not need it after execution of std_validation
  # tempdir:
  # type: File
  # outputBinding:
  #   glob: $(inputs.tempdir_name)

  
  
