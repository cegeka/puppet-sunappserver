define sunappserver::config::domain (
    $ensure              = 'present',
    $appserv_installroot = $sunappserver::params::appserv_installroot,
    $runas               = 'appserv',
    $imq_type            = 'remote'
  ) {

  if ! defined(Class['sunappserver::params']) {
    fail('You must include the sunappserver::params class before using any sunappserver defined resources')
  }

  $suffix = $title ? {
    'domain1' => '',
    default   => "-${title}"
  }

  case $imq_type {
    'remote', 'embedded': { $imq_type_real = upcase($imq_type) }
    default: {
      fail("Sunappserver::Config::Domain[${title}]: parameter imq_type must be remote or embedded")
    }
  }

  case $ensure {
    'absent': {

      file { "service/sunappserver-${title}":
        ensure => $ensure,
        path   => "/etc/init.d/sunappserver${suffix}"
      }

      file { "sysconfig/sunappserver-${title}":
        ensure => $ensure,
        path   => "/etc/sysconfig/sunappserver${suffix}"
      }

      file { "${appserv_installroot}/domains/${title}":
        ensure => $ensure,
        force  => true
      }
    }
    'present': {
      file { "service/sunappserver-${title}":
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        path   => "/etc/init.d/sunappserver${suffix}",
        source => 'puppet:///modules/sunappserver/config/domain'
      }

      file { "sysconfig/sunappserver-${title}":
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        path    => "/etc/sysconfig/sunappserver${suffix}",
        content => template('sunappserver/config/sysconfig.erb')
      }

      file { "${appserv_installroot}/domains/${title}":
        ensure => 'directory',
        owner  => $runas,
        mode   => '0750'
      }

      augeas { "${title}/config/jms-service/type":
        lens    => 'Xml.lns',
        incl    => "${appserv_installroot}/domains/${title}/config/domain.xml",
        changes => [
          "set domain/configs/config/jms-service/#attribute/type ${imq_type_real}",
        ]
      }
    }
    default: {
      fail("Sunappserver::Config::Domain['${title}']: parameter ensure must be present or absent")
    }
  }
}
