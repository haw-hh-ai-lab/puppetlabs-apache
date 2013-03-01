# deploy apache configuration file
# by default we assume it's a global configuration file
#
# adapted from [http://www.immerda.ch immerda.ch project]
#
define apache::config::file(
    $ensure = present,
    $source = undef,
    $content = undef,
    $destination = undef,
    $target = undef,
){
    include apache::params

    if $::apache::params::conf_dir {
      $local_conf_dir = "${::apache::params::conf_dir}"
    } else {
      $local_conf_dir = '/etc/apache2/conf.d/'
    }

    if $destination {
      $real_destination = $destination
    } else {
      $real_destination = "${::apache::params::conf_dir}/${name}" 
    }
        
    file{"apache_${name}":
        ensure => $ensure,
        path => $real_destination,
        notify => Service[apache],
        owner => $::apache::params::user, 
        group => $::apache::params::group, 
        mode => 0644;
        require => Package['httpd'],
    }
    
    case $ensure {
       'present' : {
            if $content {
                File["apache_${name}"]{
                    content => $content,
                }
            } elsif $source {
                File["apache_${name}"]{
                    source => $source,
               }
            } else {
                File["apache_${name}"]{
                    source => [
                        "puppet:///modules/site_apache/${confdir}/${::fqdn}/${name}",
                        "puppet:///modules/site_apache/${confdir}/${apache::cluster_node}/${name}",
                        "puppet:///modules/site_apache/${confdir}/${::operatingsystem}.${::lsbdistcodename}/${name}",
                        "puppet:///modules/site_apache/${confdir}/${::operatingsystem}/${name}",
                        "puppet:///modules/site_apache/${confdir}/${name}",
                        "puppet:///modules/apache/${confdir}/${::operatingsystem}.${::lsbdistcodename}/${name}",
                        "puppet:///modules/apache/${confdir}/${::operatingsystem}/${name}",
                        "puppet:///modules/apache/${confdir}/${name}"
                    ],
                }
            }
       
       }
       'link' : {
           if $target {
                File["apache_${name}"]{
                    target => $target
                }
           }
       }
    }
        
}