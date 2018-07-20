cwltool --print-dot wf_pgap.cwl input.yaml > pgap.dot
dot -Tsvg pgap.dot -o pgap.svg
dot -Tpng pgap.dot -o pgap.png
