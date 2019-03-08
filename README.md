# PGAP
NCBI Prokaryotic Genome Annotation Pipeline

NCBI Prokaryotic Genome Annotation Pipeline is designed to annotate
bacterial and archaeal genomes (chromosomes and plasmids).

Genome annotation is a multi-level process that includes prediction of
protein-coding genes, as well as other functional genome units such as
structural RNAs, tRNAs, small RNAs, pseudogenes, control regions,
direct and inverted repeats, insertion sequences, transposons and
other mobile elements.

NCBI has developed an automatic prokaryotic genome annotation pipeline
that combines ab initio gene prediction algorithms with homology based
methods. The first version of NCBI Prokaryotic Genome Automatic
Annotation Pipeline (PGAAP; see Pubmed Article) developed in 2005 has
been replaced with an upgraded version that is capable of processing a
larger data volume.


## Instructions

To run the PGAP pipeline you will need Linux, Docker, CWL (Common
Workflow Language), and about 30GB of supplemental data. We provide
instructions here for running under the CWL reference implementation,
cwltool. Full instructions for installing, running, and interpreting
the results may be found in our [wiki](https://github.com/ncbi/pgap/wiki).

## References

### NCBI

[NCBI prokaryotic genome annotation pipeline.](https://www.ncbi.nlm.nih.gov/pubmed/27342282)\
Tatusova T, DiCuccio M, Badretdin A, Chetvernin V, Nawrocki EP, Zaslavsky L, Lomsadze A, Pruitt KD, Borodovsky M, Ostell J.\
Nucleic Acids Res. 2016 Aug 19;44(14):6614-24. Epub 2016 Jun 24.

[RefSeq: an update on prokaryotic genome annotation and curation.](https://www.ncbi.nlm.nih.gov/pubmed/29112715)\
Haft DH, DiCuccio M, Badretdin A, Brover V, Chetvernin V, O'Neill K, Li W, Chitsaz F, Derbyshire MK, Gonzales NR, Gwadz M, Lu F, Marchler GH, Song JS, Thanki N, Yamashita RA, Zheng C, Thibaud-Nissen F, Geer LY, Marchler-Bauer A, Pruitt KD.\
Nucleic Acids Res. 2018 Jan 4;46(D1):D851-D860.

### GeneMarkS

[GeneMarkS: a self-training method for prediction of gene starts in microbial genomes. Implications for finding sequence motifs in regulatory regions.](https://www.ncbi.nlm.nih.gov/pubmed/11410670)\
Besemer J, Lomsadze A, Borodovsky M.\
Nucleic Acids Research. 2001;29(12):2607-2618.

### TIGRFAMs

[TIGRFAMs: a protein family resource for the functional identification of proteins.](https://www.ncbi.nlm.nih.gov/pubmed/11125044)\
Haft DH, Loftus BJ, Richardson DL, Yang F, Eisen JA, Paulsen IT, White O.\
Nucleic Acids Res. 2001 Jan 1;29(1):41-3.

[The TIGRFAMs database of protein families.](https://www.ncbi.nlm.nih.gov/pubmed/12520025)\
Haft DH, Selengut JD, White O.\
Nucleic Acids Res. 2003 Jan 1;31(1):371-3.

[TIGRFAMs and Genome Properties: tools for the assignment of molecular function and biological process in prokaryotic genomes.](https://www.ncbi.nlm.nih.gov/pubmed/17151080)\
Selengut JD, Haft DH, Davidsen T, Ganapathy A, Gwinn-Giglio M, Nelson WC, Richter AR, White O.\
Nucleic Acids Res. 2007 Jan;35(Database issue):D260-4. Epub 2006 Dec 6.

[TIGRFAMs and Genome Properties in 2013.](https://www.ncbi.nlm.nih.gov/pubmed/23197656)\
Haft DH, Selengut JD, Richter RA, Harkins D, Basu MK, Beck E.\
Nucleic Acids Res. 2013 Jan;41(Database issue):D387-95. doi: 10.1093/nar/gks1234. Epub 2012 Nov 28.

## LICENSING TERMS

### NCBI PGAP CWL

The NCBI PGAP CWL and other code authored by NCBI is a "United States
Government Work" under the terms of the United States Copyright
Act. It was written as part of the authors' official duties as United
States Government employees and thus cannot be copyrighted. This
software is freely available to the public for use. The National
Library of Medicine and the U.S. Government have not placed any
restriction on its use or reproduction.

Although all reasonable efforts have been taken to ensure the accuracy
and reliability of the software and data, the NLM and the
U.S. Government do not and cannot warrant the performance or results
that may be obtained by using this software or data. The NLM and the
U.S. Government disclaim all warranties, express or implied, including
warranties of performance, merchantability or fitness for any
particular purpose.

Please cite NCBI in any work or product based on this material.

### Third-party tools

The Docker image contains third-party tools distributed under the
licensing terms of the respective license holders.

### GeneMarkS

GeneMarkS is distributed as part of PGAP with limited rights of use
and redistribution from the Georgia Tech Research Corporation. See the
[full text of the license](GeneMarkS_Software_License.txt).

### TIGRFAMs

The original TIGRFAMs database was a research project of the J. Craig
Venter Institute \(JCVI\) . TIGRFAMs, short for The Institute for
Genomic Research's database of protein families, is a collection of
manually curated protein families focusing primarily on prokaryotic
sequences. It consists of hidden Markov models \(HMMs\), multiple
sequence alignments, Gene Ontology \(GO\) terminology, Enzyme Commission
\(EC\) numbers, gene symbols, protein family names, descriptive text,
cross-references to related models in TIGRFAMs and other databases,
and pointers to the literature. The work has been described in the
articles listed in the References section above and use of the
TIGRFAMs database must grant proper attribution by citing those four
articles.

As of April 2018, rights were transferred to the National Center for
Biotechnology Information \(NCBI\), National Library of Medicine, NIH,
for the data to be made available for distribution under a Creative
Commons Attribution-ShareAlike 4.0 license.  Please see
(https://creativecommons.org/licenses/by-sa/4.0/) for a brief summary
of the license and
(https://creativecommons.org/licenses/by-sa/4.0/legalcode) to see the
full text.
