class sunappserver::config {

  include sunappserver::params

  file { '/etc/sysconfig/sunappserver' :
    ensure  => file,
    content => template('sunappserver/sunappserver-sysconfig.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { $sunappserver::imq_home :
    ensure => directory,
    owner  => $sunappserver::runas,
    group  => 'appserv'
  }

  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${sunappserver::runas} ${sunappserver::params::appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${sunappserver::params::appserv_installroot} | grep ${sunappserver::runas}`",
  }

  augeas { "domain/configs/config/jms-service/type/${sunappserver::imq_type_real}" :
    lens    => 'Xml.lns',
    incl    => '/opt/appserver/domains/domain1/config/domain.xml',
    context => '/files/opt/appserver/domains/domain1/config/domain.xml',
    changes => [
      "set domain/configs/config/jms-service/#attribute/type ${sunappserver::imq_type_real}",
    ],
    onlyif  => "match domain/configs/config/jms-service/#attribute/type[. =\"${sunappserver::imq_type_real}\"] size == 0"
  }

}
