// Import genetic module functions
include { saveFiles; getSoftwareName; getProcessName; initOptions } from './functions'

params.options = [:]
options        = initOptions(params.options)

process CELLRANGER_COUNT {
    tag "${meta.id}"
    label 'process_high'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName("${task.process}"), meta:meta, publish_by_meta:['id']) }
    container params.docker_cellranger

    input:
    tuple val(meta), (path(reads), stageAs: 'fastqs/*')
    path  reference, stageAs: 'transcriptome.tar.gz'

    output:
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/web_summary.html")              , emit: summary_html
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/metrics_summary.csv")           , emit: summary_csv
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/molecule_info.h5")              , emit: molecule_h5
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/raw_feature_bc_matrix.h5")      , emit: raw_feature_matrix_h5
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/filtered_feature_bc_matrix.h5") , emit: filtered_feature_matrix_h5
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/possorted_genome_bam.bam")      , emit: bam
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/possorted_genome_bam.bam.bai")  , emit: bai
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/cloupe.cloupe")                 , emit: loupe
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/filtered_feature_bc_matrix/*")  , emit: filtered_feature_matrix
    tuple val(meta), path("*${meta.gem}_${meta.id}/outs/raw_feature_bc_matrix/*")       , emit: raw_feature_matrix
    path  "versions.yml"                                                                , emit: versions

    //tuple val(meta), path('*${meta.gem}_${meta.id}/outs/feature_reference.csv')        , optional:true, emit: feature_reference_csv
    //tuple val(meta), path('*${meta.gem}_${meta.id}/outs/target_panel.csv')             , optional:true, emit: targeted_gex_csv

    script:
    """
    #!/usr/bin/env bash

    # verbose output for executed commands, and fail on error
    set -xe

    # configure transcriptome reference directory
    # this should eliminate subdirectory ambiguity in the tarball
    # see here: https://stackoverflow.com/a/66449935/4536078
    mkdir transcriptome
    tar -xvzf transcriptome.tar.gz -C transcriptome --strip-components=1

    # run cellranger count
    cellranger count \\
        --id="${meta.gem}_${meta.id}" \\
        --fastqs=fastqs \\
        --sample="${meta.id}" \\
        --transcriptome=transcriptome \\
        --expect-cells 7000

    # get software version
    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$(cellranger --version | cut -d ' ' -f 2 | cut -d '-' -f 2)
    END_VERSIONS
    """
}

