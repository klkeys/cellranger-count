//
// Compile H5 files from cellranger count and run cellranger aggr 
//

params.cellranger_options = [:]

include { CELLRANGER_AGGR } from '../../modules/local/cellranger_aggr' addParams( options: params.cellranger_options )

workflow CELLRANGER_AGGREGATE {
    take:
    molecule_h5 // channel: [ val(meta), [ molecule_h5_files ] ]

    main:

    ch_filtered_h5_matrix = Channel.empty()
    ch_versions = Channel.empty()

    // prepare CSV of molecule info h5 files for cellranger aggr
    molecule_h5.map {
        sample_id = it[0].fastq_id
        values    = it[1]
        return [sample_id, files].join(',')
    }
    .collectFile(
        name: 'molecule_info.csv',
        newLine: true,
        seed: "sample_id,molecule_h5"
    )
    .set { molecule_info_csv }

    // run cellranger aggr
    CELLRANGER_AGGR ( molecule_info_csv ).out.filtered_feature_matrix_h5.set { ch_filtered_h5 }

    ch_versions = ch_versions.mix(CELLRANGER_AGGR.out.versions.first())

    emit:
    filtered_h5_matrix = ch_filtered_h5.ifEmpty(null) // channel: [ filtered_h5_matrix ]
    versions = ch_versions.ifEmpty(null)           // channel: [ versions.yml ]
}
