# scopus-to-rdf
Mapping selected data items from SCOPUS API output to RDF

## Prerequisites

In order to install and execute the pipeline, git and docker must be installed on the computer.

## Install

Clone this repository

```shell
git clone https://github.com/fossr-project/scopus-to-rdf.git scopus-to-rdf
```

## Prepare data sources

Copy the source [JSON Lines](https://jsonlines.org/) files inside a `data/source` folder inside `scopus-to-rdf`. They need to be split in subfolders by mapping type (currently `paper`, `paper-references`, `author`, and `affiliation` are supported).
Below a sample structure is shown.

```
│ ...
├── data
│   └── source
│       ├── affiliation
│       │   └── affiliation.jsonl
│       ├── author
│       │   └── author.jsonl
│       ├── paper
│       │   ├── paper_2023.jsonl
│       │   └── paper_2024.jsonl
│       └── paper-references
│           └── author.jsonl
│ ...
```

## Run pipeline

Build the docker image and run the container with docker compose.

```shell
cd scopus-to-rdf
docker compose up -d
```

## Check results

The resulting RDF triples are saved in the `data/rdf` folder as N-Triples files, both all together in the `all.nt` file and separated by each input file.
Below the new structure correponding to the example above is shown.

```
│ ...
├── data
│   ├── source
│   │   ├── affiliation
│   │   │   └── affiliation.jsonl
│   │   ├── author
│   │   │   └── author.jsonl
│   │   ├── paper
│   │   │   ├── paper_2023.jsonl
│   │   │   └── paper_2024.jsonl
│   │   └── paper-references
│   │       └── author.jsonl
│   └── rdf
│       ├── affiliation
│       │   └── affiliation.nt
│       ├── author
│       │   └── author.nt
│       ├── paper
│       │   ├── paper_2023.nt
│       │   └── paper_2024.nt
│       ├── paper-references
│       │   └── author.nt
│       └── all.nt
│ ...
```
