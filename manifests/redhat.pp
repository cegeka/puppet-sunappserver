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

  file { $sunappserver::imq_home :
    ensure => directory,
    owner  => $sunappserver::runas,
    group  => 'appserv',
  }

  service { 'sunappserver' :
    ensure    => $sunappserver::appserver_status,
    enable    => true,
    hasstatus => true,
    require   => Service['imq'],
  }

  service { 'imq' :
    ensure    => $sunappserver::imq_status,
    enable    => true,
    hasstatus => true,
    require   => [ Package['sunappserver'], File[$sunappserver::imq_home] ],
  }
  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${sunappserver::runas} ${sunappserver::params::appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${sunappserver::params::appserv_installroot} | grep ${sunappserver::runas}`",
    require => Package['sunappserver'],
  }

}
