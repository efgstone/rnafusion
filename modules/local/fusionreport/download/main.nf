process FUSIONREPORT_DOWNLOAD {
    tag 'fusionreport'
    label 'process_medium'

    // Note: 2.7X indices incompatible with AWS iGenomes.
    conda "bioconda::star=2.7.9a"
    container "docker.io/clinicalgenomics/fusion-report:2.1.5p2.1"

    input:
    val(username)
    val(passwd)

    output:
    path "*"                , emit: reference
    path "versions.yml"     , emit: versions

    script:
    def args = task.ext.args ?: ''
    """
    fusion_report download --cosmic_usr "$username" --cosmic_passwd "$passwd" $args ./

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fusion_report: \$(fusion_report --version | sed 's/fusion-report //')
    END_VERSIONS
    """

    stub:
    """
    touch cosmic.db
    touch fusiongdb2.db
    touch fusiongdb.db
    touch mitelman.db
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fusion_report: \$(fusion_report --version | sed 's/fusion-report //')
    END_VERSIONS
    """

}
