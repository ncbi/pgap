# PGAP
NCBI Prokaryotic Genome Annotation Pipeline

NCBI Prokaryotic Genome Annotation Pipeline is designed to annotate bacterial and archaeal genomes (chromosomes and plasmids).

Genome annotation is a multi-level process that includes prediction of protein-coding genes, as well as other functional genome units such as structural RNAs, tRNAs, small RNAs, pseudogenes, control regions, direct and inverted repeats, insertion sequences, transposons and other mobile elements.

NCBI has developed an automatic prokaryotic genome annotation pipeline that combines ab initio gene prediction algorithms with homology based methods. The first version of NCBI Prokaryotic Genome Automatic Annotation Pipeline (PGAAP; see Pubmed Article) developed in 2005 has been replaced with an upgraded version that is capable of processing a larger data volume.  NCBI's annotation pipeline depends on several internal databases and is not currently available for download or use outside of the NCBI environment.


## Installation

To run the PGAP pipeline you will need Linux, Docker and CWL (Common
Workflow Language). We provide instructions here for running under the
CWL reference implementation, cwltool.


### Quick start

These instructions assume that you have a python virtualenv, pip, and docker installed. We provide more details about how to install these prerequisites below.

```shell
(cwl) ~$ pip install -U wheel setuptools
(cwl) ~$ pip install -U cwltool[deps] PyYAML cwlref-runner
(cwl) ~$ git clone https://github.com/ncbi-gpipe/pgap.git
(cwl) ~$ cd pgap
(cwl) ~/pgap$ download supplemental data instructions here
(cwl) ~/pgap$ run instructions here
```

### Installation summary

The PGAP Pipeline only runs on Linux and requires three types of items to run. The CWL instructions, about 30GB of supplemental data, and Docker containers. Note that
Docker (http://docker.com) requires root to install.

Prerequisites include:
- python
- docker
- python packages
- wheel
- setuptools
- PyYAML
- cwlref-runner
- cwltool

### Retrieving the CWL code

The CWL software is available at GitHub at https://github.com/ncbi-gpipe/pgap,
and can be retrieved with git like:

```shell
~$ git clone https://github.com/ncbi-gpipe/pgap.git
```

### Prerequisites

You will need to install the prerequisites if they're not already installed on
your system.

e.g.,

The instructions that follow use pip and virtualenv, which are usually
included with most python installs, so try:

```shell
~$ pip --version
~$ virtualenv --version
```
If pip is not installed see https://pip.pypa.io/en/stable/installing/ for installation instructions.

Virtualenv can be easily installed with pip:

```shell
~$ pip install virtualenv
```

To create a virtualenv for your installation of CWL and PGAP:

```shell
~$ virtualenv --python=python3 cwl
```

### Installing CWL

```shell
~$ source cwl/bin/activate
(cwl) ~$ pip install -U wheel setuptools
(cwl) ~$ pip install -U cwltool[deps] PyYAML cwlref-runner
```

### Installing Docker

It is recommended that you install Docker instead of the more limited uDocker.
Detailed instructions may be found on the docker website. [Docker
Install](https://docs.docker.com/install/). Please install the latest version
of docker, it is usually newer than the one that comes with your distribution.
Note that it requires root access to install, and the user who will be running
the software will need to be in the docker group. The required docker
containers images will download automatically the first time the pipeline runs.
Afterwards, they will be cached and subsequent runs will execute much faster.

Make sure that you're running Docker and that you are part of the group that has
docker permissions by running

```shell
(cwl) ~$ docker run hello-world
```

You should see a message that starts with:
```

Hello from Docker!
This message shows that your installation appears to be working correctly.

```

### Download the Supplemental Data

TBD

### Run the pipeline

TDB

## References

[NCBI prokaryotic genome annotation pipeline.](https://www.ncbi.nlm.nih.gov/pubmed/27342282)\
Tatusova T, DiCuccio M, Badretdin A, Chetvernin V, Nawrocki EP, Zaslavsky L, Lomsadze A, Pruitt KD, Borodovsky M, Ostell J.\
Nucleic Acids Res. 2016 Aug 19;44(14):6614-24. Epub 2016 Jun 24.

[RefSeq: an update on prokaryotic genome annotation and curation.](https://www.ncbi.nlm.nih.gov/pubmed/29112715)\
Haft DH, DiCuccio M, Badretdin A, Brover V, Chetvernin V, O'Neill K, Li W, Chitsaz F, Derbyshire MK, Gonzales NR, Gwadz M, Lu F, Marchler GH, Song JS, Thanki N, Yamashita RA, Zheng C, Thibaud-Nissen F, Geer LY, Marchler-Bauer A, Pruitt KD.\
Nucleic Acids Res. 2018 Jan 4;46(D1):D851-D860.

[TIGRFAMs: a protein family resource for the functional identification of proteins.](https://www.ncbi.nlm.nih.gov/pubmed/11125044)\
Haft DH, Loftus BJ, Richardson DL, Yang F, Eisen JA, Paulsen IT, White O.\
Nucleic Acids Res. 2001 Jan 1;29(1):41-3.

[The TIGRFAMs database of protein families.](https://www.ncbi.nlm.nih.gov/pubmed/12520025)\
Haft DH, Selengut JD, White O.\
Nucleic Acids Res. 2003 Jan 1;31(1):371-3.

[TIGRFAMs and Genome Properties in 2013.](https://www.ncbi.nlm.nih.gov/pubmed/23197656)\
Haft DH, Selengut JD, Richter RA, Harkins D, Basu MK, Beck E.\
Nucleic Acids Res. 2013 Jan;41(Database issue):D387-95. doi: 10.1093/nar/gks1234. Epub 2012 Nov 28.

[TIGRFAMs and Genome Properties: tools for the assignment of molecular function and biological process in prokaryotic genomes.](https://www.ncbi.nlm.nih.gov/pubmed/17151080)\
Selengut JD, Haft DH, Davidsen T, Ganapathy A, Gwinn-Giglio M, Nelson WC, Richter AR, White O.\
Nucleic Acids Res. 2007 Jan;35(Database issue):D260-4. Epub 2006 Dec 6.

## Public Domain notice

National Center for Biotechnology Information.

This software is a "United States Government Work" under the terms of the
United States Copyright Act.  It was written as part of the authors'
official duties as United States Government employees and thus cannot
be copyrighted.  This software is freely available to the public for
use. The National Library of Medicine and the U.S. Government have not
placed any restriction on its use or reproduction.

Although all reasonable efforts have been taken to ensure the accuracy
and reliability of the software and data, the NLM and the U.S.
Government do not and cannot warrant the performance or results that
may be obtained by using this software or data. The NLM and the U.S.
Government disclaim all warranties, express or implied, including
warranties of performance, merchantability or fitness for any
particular purpose.

Please cite NCBI in any work or product based on this material.

