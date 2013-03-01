# deploy apache configuration file (global)
# wrapper for apache::config::file
define apache::config::global(
    $ensure = present,
    $source = undef,
    $content = undef,
    $destination = undef,
    $target = undef,
){
    apache::config::file { "${name}":
        ensure => $ensure,
        source => $source,
        content => $content,
        destination => $destination,
        target => $target,
    }
}