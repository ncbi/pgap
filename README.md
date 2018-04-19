# PGAP
NCBI Prokaryotic Genome Annotation Pipeline

NCBI Prokaryotic Genome Annotation Pipeline is designed to annotate bacterial and archaeal genomes (chromosomes and plasmids).

Genome annotation is a multi-level process that includes prediction of protein-coding genes, as well as other functional genome units such as structural RNAs, tRNAs, small RNAs, pseudogenes, control regions, direct and inverted repeats, insertion sequences, transposons and other mobile elements.

NCBI has developed an automatic prokaryotic genome annotation pipeline that combines ab initio gene prediction algorithms with homology based methods. The first version of NCBI Prokaryotic Genome Automatic Annotation Pipeline (PGAAP; see Pubmed Article) developed in 2005 has been replaced with an upgraded version that is capable of processing a larger data volume.  NCBI's annotation pipeline depends on several internal databases and is not currently available for download or use outside of the NCBI environment.

This implementation is intended to be accessible outside of the NCBI network and availible to all users. It is based on CWL and Docker containers. This is a work in progress and not currently functional.
