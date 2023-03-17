// Import genetic module functions
include { saveFiles; getSoftwareName; getProcessName; initOptions } from './functions'

params.options = [:]
options        = initOptions(params.options)

process CELLRANGER_AGGR {
    tag "CELLRANGER_AGGR"
    label 'process_high'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName("${task.process}"), meta:meta, publish_by_meta:['id']) }
    container params.docker_cellranger

    input:
    path aggr_csv

    output:
    tuple val(meta), path("*cellranger_aggr/outs/web_summary.html")              , emit: summary_html
    tuple val(meta), path("*cellranger_aggr/outs/summary.json")                  , emit: summary_json
    tuple val(meta), path("*cellranger_aggr/outs/filtered_feature_bc_matrix/*")  , emit: filtered_feature_matrix
    tuple val(meta), path("*cellranger_aggr/outs/filtered_feature_bc_matrix.h5") , emit: filtered_feature_matrix_h5
    tuple val(meta), path("*cellranger_aggr/outs/aggregation.csv")               , emit: aggregation_csv
    tuple val(meta), path("*cellranger_aggr/outs/cloupe.cloupe")                 , emit: loupe 
    path  "versions.yml"                                                         , emit: versions

    script:
    """
    #!/usr/bin/env bash

    # verbose output for executed commands, and fail on error
    set -xe

    # run cellranger aggr 
    cellranger aggr \\
        --id="cellranger_aggr" \\
        --csv="${aggr_csv}" \\
        --normalize="mapped"

    # get software version
    cat <<-END_VERSIONS > versions.yml
    ${getProcessName(task.process)}:
        ${getSoftwareName(task.process)}: \$(cellranger --version | cut -d ' ' -f 2 | cut -d '-' -f 2)
    END_VERSIONS
    """
}

