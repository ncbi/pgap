cwlVersion: v1.0
class: CommandLineTool
baseCommand: fastaval.sh
label: fastaval
requirements:
  - class: InlineJavascriptRequirement
  
inputs:
  in:
    type: File?
    inputBinding:
      prefix: '-in'
  input:
    type: File?
    inputBinding:
  outname:
    type: string?
    default: "fastaval.xml"
    inputBinding:
      prefix: '-out'
  check_min_seqlen:
    type: int?
    inputBinding:
      prefix: '-check_min_seqlen'
  max_seqid_count:
    type: int?
    inputBinding:
      prefix: '-max_seqid_count'
    doc: Maximum number of sequence IDs per sequence (0 means unlimited)
  allow_implicit_gnl:
    type: boolean?
    inputBinding:
      prefix: '-allow_implicit_gnl'
    doc: >-
      Allow sequence IDs lacking the gnl| prefix to be interpreted as 'general' 
      db/tag IDs (default is not to allow this)
  disallow_seqid_type:
    type: string?
    inputBinding:

      prefix: '-disallow_seqid_type'
    doc: Sequence ID types that are not allowed.
  check_internal_ns:
    type: boolean?
    inputBinding:
      prefix: '-check_internal_ns'
    doc: Check for internal N's
  ignore_all_errors:
        type: boolean?
outputs:
  out:
        type: File
        outputBinding:
            glob: $(inputs.outname)
  success:
        type: boolean
        outputBinding:
            outputEval: $(true)
            
