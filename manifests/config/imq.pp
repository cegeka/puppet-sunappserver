class sunappserver::config::imq(
    $ensure              = 'present',
    $runas               = 'appserv',
    $appserv_installroot = $sunappserver::params::appserv_installroot,
    $imq_port            = $sunappserver::params::imq_port,
  ) {

  if ! defined(Class['sunappserver::params']) {
    fail('You must include the sunappserver::params class before using this class')
  }

  $imq_home = "${appserv_installroot}/imq"

  case $ensure {
    'present': {

      file { 'service/imq':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0750',
        path   => '/etc/init.d/imq',
        source => 'puppet:///modules/sunappserver/config/imq'
      }

      file { 'sysconfig/imq':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        path    => '/etc/sysconfig/imq',
        content => template('sunappserver/config/imq.erb')
      }

      file { $imq_home:
        ensure => 'directory',
        owner  => $runas,
        mode   => '0750'
      }
    }
    'absent': {
      file { 'service/imq':
        ensure => 'absent',
        path   => '/etc/init.d/imq'
      }

      file { 'sysconfig/imq':
        ensure => 'absent',
        path   => '/etc/sysconfig/imq'
      }
    }
    default: {
      fail('Class[sunappserver::config::imq]: parameter ensure must be present or absent')
    }
  }
}
