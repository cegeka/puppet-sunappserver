class sunappserver::redhat {

  package { 'sunappserver':
    ensure   => $sunappserver::real_appserver_ensure,
  }

  file { '/etc/sysconfig/sunappserver' :
    ensure    => file,
    content   => template('sunappserver/sunappserver-sysconfig.erb'),
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
  }

  service { 'sunappserver' :
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Service['imq'],
  }

  service { 'imq' :
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package['sunappserver'],
  }
  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${sunappserver::runas} ${sunappserver::params::appserv_installroot}",
    onlyif  => "/usr/bin/test `/usr/bin/stat -c %U ${sunappserver::params::appserv_installroot} | grep ${sunappserver::runas}`",
    require => Package['sunappserver'],
  }

}
