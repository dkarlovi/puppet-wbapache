class wbapache {
    # init defaults for all children
    contain ::wbapache::coreframework::defaults

    $src_root  = "/vagrant"
    $var_root  = "/var/app"
    $doc_root  = "${src_root}/src"
    $data_root = "${var_root}/data"

    # NOTE: bug workaround
    # puppetlabs/apache will try to chown a (NFS-exported) docroot to root:root (and fail)
    file { "${doc_root}":
        path => "${doc_root}",
    #    require => Vcsrepo["${src_root}"],
        ensure  => directory,
    }

    include apache
}
