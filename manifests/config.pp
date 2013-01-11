class sunappserver::config($runas=undef, $imq_type=undef, $imq_home=undef) {

  include sunappserver::params

  file { '/etc/sysconfig/sunappserver' :
    ensure  => file,
    content => template('sunappserver/sunappserver-sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $imq_home :
    ensure => directory,
    owner  => $runas,
    group  => 'appserv'
  }

  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${runas} ${sunappserver::params::appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${sunappserver::params::appserv_installroot} | grep ${runas}`",
  }

  augeas { "domain/configs/config/jms-service/type/${imq_type}" :
    lens    => 'Xml.lns',
    incl    => '/opt/appserver/domains/domain1/config/domain.xml',
    context => '/files/opt/appserver/domains/domain1/config/domain.xml',
    changes => [
      "set domain/configs/config/jms-service/#attribute/type ${imq_type}",
    ],
    onlyif  => "match domain/configs/config/jms-service/#attribute/type[. =\"${imq_type}\"] size == 0"
  }

}
