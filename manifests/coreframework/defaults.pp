class wbapache::coreframework::defaults {
    $aliases = [
        {
            alias => '/asset',
            path  => "${var_root}/cache/asset",
        },
        {
            alias => '/repository',
            path  => "${data_root}/repository",
        },
        {
            alias => '/framework/style',
            path  => "${src_root}/framework/asset/styles",
        },
        {
            alias => '/framework/javascript',
            path  => "${src_root}/framework/asset/javascript/lib",
        },
    ]
    $rewrite_rules = [
        {
            comment      => ['HTTP => HTTPS'],
            rewrite_cond => ['%{HTTPS} off', '%{HTTP_HOST} ^(.*)$ [NC]'],
            rewrite_rule => ['^(.*)$ https://%1$1 [R=301,L,QSA]'],
        },
        {
            comment      => ['non-www => www'],
            rewrite_cond => ['%{HTTP_HOST} !^(api|www)\.(.*)$ [NC]', '%{HTTP_HOST} ^(.*)$ [NC]'],
            rewrite_rule => ['^(.*)$ https://www.%1$1 [R=301,L,QSA]'],
        },
        {
            comment      => ['pass through request to an existing file'],
            rewrite_cond => ['%{DOCUMENT_ROOT}/%{REQUEST_FILENAME} -f'],
            rewrite_rule => ['^.*$ - [QSA,L]'],
        },
        {
            comment      => ['ignore aliases'],
            rewrite_rule => ['^/(asset|repository|framework) - [L]'],
        },
        {
            comment      => ['enforce trailing slashes on all URLs not starting with /angular'],
            rewrite_cond => ['%{REQUEST_URI} !(.*)/$', '%{REQUEST_URI} !^/angular'],
            rewrite_rule => ['^(.*)$ $1/ [QSA,L,R=301]'],
        },
        {
            comment      => ['redirect everything else to index.php'],
            rewrite_rule => ['^(.*)$ /index.php [QSA,L]'],
        },
    ]
}