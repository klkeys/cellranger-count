# klkeys/cellranger-count

**Nota bene**: this workflow is mostly a relic and is listed here for archival purposes.
The bulk of the code and repository structure is cribbed from [qbic-pipelines/cellranger](https://github.com/qbic-pipelines/cellranger). 
The functionality is subsumed ( and probably better maintained ) in [nf-core/scrnaseq](https://github.com/nf-core/scrnaseq/releases) as of version 2.0.0. 
Consider using the aforementioned sources before trying this one.

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A521.04.0-23aa62.svg?labelColor=000000)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Follow on Twitter](http://img.shields.io/badge/twitter-%40nf__core-1DA1F2?labelColor=000000&logo=twitter)](https://twitter.com/nf_core)
[![Watch on YouTube](http://img.shields.io/badge/youtube-nf--core-FF0000?labelColor=000000&logo=youtube)](https://www.youtube.com/c/nf-core)

## Introduction

A cloud implementation of 10X Genomics CellRanger workflow.

## Pipeline summary

1. Read QC ([`FastQC`](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/))
2. Count reads ([`cellranger count`](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/tutorial_ct))
3. Aggregate read counts ([`cellranger aggr`](https://support.10xgenomics.com/single-cell-gene-expression/software/pipelines/latest/using/aggregate))
4. Present QC for raw read, alignment, and sample similarity ([`MultiQC`](http://multiqc.info/), [`R`](https://www.r-project.org/))

## Quick Start

1. Install [`Nextflow`](https://www.nextflow.io/docs/latest/getstarted.html#installation) (`>=21.04.0`)

2. Install any of [`Docker`](https://docs.docker.com/engine/installation/), [`Singularity`](https://www.sylabs.io/guides/3.0/user-guide/), [`Podman`](https://podman.io/), [`Shifter`](https://nersc.gitlab.io/development/shifter/how-to-use/) or [`Charliecloud`](https://hpc.github.io/charliecloud/) for full pipeline reproducibility _(please only use [`Conda`](https://conda.io/miniconda.html) as a last resort; see [docs](https://nf-co.re/usage/configuration#basic-configuration-profiles))_. Note: This pipeline does not currently support running with Conda on macOS if the `--remove_ribo_rna` parameter is used because the latest version of the SortMeRNA package is not available for this platform.

3. Download the pipeline and test it on a minimal dataset with a single command:

    ```console
    nextflow run klkeys/cellranger-count -profile test,<docker/singularity/podman/shifter/charliecloud/conda/institute>
    ```

    > * Please check [nf-core/configs](https://github.com/nf-core/configs#documentation) to see if a custom config file to run nf-core pipelines already exists for your Institute. If so, you can simply use `-profile <institute>` in your command. This will enable either `docker` or `singularity` and set the appropriate execution settings for your local compute environment.
    > * If you are using `singularity` then the pipeline will auto-detect this and attempt to download the Singularity images directly as opposed to performing a conversion from Docker images. If you are persistently observing issues downloading Singularity images directly due to timeout or network issues then please use the `--singularity_pull_docker_container` parameter to pull and convert the Docker image instead. Alternatively, it is highly recommended to use the [`nf-core download`](https://nf-co.re/tools/#downloading-pipelines-for-offline-use) command to pre-download all of the required containers before running the pipeline and to set the [`NXF_SINGULARITY_CACHEDIR` or `singularity.cacheDir`](https://www.nextflow.io/docs/latest/singularity.html?#singularity-docker-hub) Nextflow options to be able to store and re-use the images from a central location for future pipeline runs.
    > * If you are using `conda`, it is highly recommended to use the [`NXF_CONDA_CACHEDIR` or `conda.cacheDir`](https://www.nextflow.io/docs/latest/conda.html) settings to store the environments in a central location for future pipeline runs.

4. Start running your own analysis!

    ```console
    nextflow run klkeys/cellranger-count \
        --input samplesheet.csv \
        --transcriptome_reference s3://my-bucket/transcriptome_reference.tar.gz \
        -profile <docker/singularity/podman/conda/institute>
    ```

## Documentation

The klkeys/cellranger-count pipeline comes with documentation about the pipeline [usage](https://nf-co.re/cellranger/usage), [parameters](https://nf-co.re/cellranger/parameters) and [output](https://nf-co.re/cellranger/output).


## Credits

These scripts were originally written for use at the [Quantitative Biology Center](https://ngisweden.scilifelab.se)(QBIC), in Tuebingen, Germany, by Gisela Gabernet ([@ggabernet](https://github.com/ggabernet)).

The pipeline was re-written in Nextflow DSL2 and is primarily maintained by Kevin L. Keys ([@klkeys](https://github.com/klkeys)) formerly at [Ambys Medicines, USA](https://www.ambys.com).

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

For further information or help, don't hesitate to get in touch on the [Slack `#rnaseq` channel](https://nfcore.slack.com/channels/rnaseq) (you can join with [this invite](https://nf-co.re/join/slack)).

## Citations

If you use klkeys/cellranger-count for your analysis, please cite it using the following doi: [10.5281/zenodo.1400710](https://doi.org/10.5281/zenodo.1400710)

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

You can cite the `nf-core` publication as follows:

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
