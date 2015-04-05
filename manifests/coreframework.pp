define wbapache::coreframework (
    $domain        = $title,
    $doc_root      = $::wbapache::doc_root,
    $var_root      = $::wbapache::var_root,
    $environment   = $::wbapache::coreframework::defaults::app_environment,
    $rewrite_rules = $::wbapache::coreframework::defaults::rewrite_rules,
    $aliases       = $::wbapache::coreframework::defaults::aliases,
) {
    apache::vhost { "${domain}-http":
        docroot       => $doc_root,
        servername    => $domain,
        serveraliases => ["*.${domain}"],
        port          => "80",
        setenv        => ["APPLICATION_ENV ${environment}", "VAR_ROOT ${var_root}"],
        rewrites      => $rewrite_rules,
        aliases       => $aliases,
        require       => File["${doc_root}"],
    }

    apache::vhost { "${domain}-https":
        docroot       => $doc_root,
        servername    => $domain,
        serveraliases => ["*.${domain}"],
        port          => "443",
        setenv        => ["APPLICATION_ENV ${environment}", "VAR_ROOT ${var_root}"],
        rewrites      => $rewrite_rules,
        aliases       => $aliases,
        require       => File["${doc_root}"],
        ssl           => true,
        ssl_cert      => "/etc/pki/tls/certs/${domain}.cert",
        ssl_key       => "/etc/pki/tls/private/${domain}.key",
    }
    file { "/etc/pki/tls/certs/${domain}.cert":
        ensure => present,
        source => ["file:///vagrant/puppet/files/ssl/${domain}.cert"],
        before => Apache::Vhost["${domain}-https"],
    }
    file { "/etc/pki/tls/private/${domain}.key":
        ensure => present,
        source => ["file:///vagrant/puppet/files/ssl/${domain}.key"],
        before => Apache::Vhost["${domain}-https"],
    }
}
