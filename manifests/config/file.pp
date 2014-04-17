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

    if $destination {
      $real_destination = $destination
    } else {
      $real_destination = "${::apache::params::confd_dir}/${name}" 
    }
        
    file{"apache_${name}":
        ensure => $ensure,
        path => $real_destination,
        notify => Service[$::apache::params::service_name],
        owner => $::apache::params::user, 
        group => $::apache::params::group, 
        mode => 0644,
        require => Package[$::apache::params::service_name],
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
              fail("apache::conf:file type must either contain source or content parameter")
            }
       
       }
       'link' : {
           if $target {
                File["apache_${name}"]{
                    target => $target
                }
           } else {
             fail("not target supplied for ensure => link")
           }
       }
    }
        
}