#
# Class: sunappserver
#
# This module manages sunappserver.
# Include it to install the Sun Java System Application Server
#
# === Requires:
#
#  cegeka/puppet-stdlib
#
#
# === Parameters:
#
# [*ensure*] The desired state for the product (default: 'present').
#            - Required: no
#            - Content: 'present' | 'absent'
#
# [*appserver_version*] The version of the Application Server (default: 'latest').
#                       - Required: no
#                       - Content: String
#
# [*appserv_installroot*] The installation directory of Application Server (default: '/opt/appserver')
#                         - Required: no
#                         - Content: String
#
# [*service_state*] The status of the Application Server default domain (domain1)
#                   (default: 'running').
#                       - Required: no
#                       - Content: String
#
# [*service_enable*] The state of the Application Server default domain service (default: 'running')
#                    - Required: no
#                    - Content: 'running' | 'stopped'
#
# [*runas*] The user under which the Application Server process is running (default: 'appserv').
#                       - Required: no
#                       - Content: String
#
# [*imq_type*] The type of the IMQ Message Broker (default: 'remote').
#                       - Required: no
#                       - Content: String
#
# [*imq_state*] The state of the IMQ Message Broker service (if the type is remote) (default: 'running')
#               - Required: no
#               - Content: 'running' | 'stopped'
#
# [*imq_home*] The home of the IMQ Message Broker (default: '/opt/appserver/imq').
#                       - Required: no
#                       - Content: String
#
# [*imq_port*] The port of the IMQ Message Broker (default: '7676').
#                       - Required: no
#                       - Content: String
#
# [*use_default_domain*] Should the default domain (domain1) exist? (default: true)
#                        - Required: no
#                        - Content: Boolean
#
# === Sample Usage:
#
#  class { sunappserver:
#    appserver_version => '9.1.01',
#  }
#
#  class { sunappserver:
#    ensure => 'absent',
#  }
#
class sunappserver (
  $ensure              = 'present',
  $appserver_version   = undef,
  $appserv_installroot = $sunappserver::params::appserv_installroot,
  $service_state       = 'running',
  $service_enable      = true,
  $runas               = 'appserv',
  $imq_type            = 'remote',
  $imq_state           = 'running',
  $imq_home            = "${sunappserver::params::appserv_installroot}/imq",
  $imq_port            = $sunappserver::params::imq_port,
  $use_default_domain  = true
) inherits sunappserver::params {

  include stdlib

  case $service_state {
    'running', 'stopped': { $service_state_real = $service_state }
    default: {
      fail('Class[sunappserver]: parameter service_state must be running or stopped')
    }
  }

  case $imq_state {
    'running', 'stopped': { $imq_state_real = $imq_state }
    default: {
      fail('Class[sunappserver]: parameter imq_state must be running or stopped')
    }
  }

  case $imq_type {
    'remote': {
      $imq_type_real = upcase($imq_type)
    }
    'embedded': {
      $imq_type_real = upcase($imq_type)
    }
    default: {
      fail('Class[sunappserver]: parameter imq_type must be remote or embedded')
    }
  }

  class { 'sunappserver::package':
    ensure            => $ensure,
    appserver_version => $appserver_version
  }

  class { 'sunappserver::config':
    runas    => $runas,
    imq_type => $imq_type_real,
    imq_home => $imq_home
  }

  if ( $use_default_domain == true ) {
    sunappserver::config::domain { 'domain1':
      runas               => $runas,
      appserv_installroot => $appserv_installroot
    }

    class { 'sunappserver::service':
      ensure => $service_state_real,
      enable => $service_enable
    }

    Sunappserver::Config::Domain['domain1'] ~> Class['sunappserver::service']
    Class['sunappserver::config'] ~> Class['sunappserver::service']

  } else {

    sunappserver::config::domain { 'domain1':
      ensure              => 'absent',
      appserv_installroot => $appserv_installroot
    }
  }

  if $imq_type == 'remote' {
    class { 'sunappserver::config::imq':
      runas => $runas
      }

    class { 'sunappserver::imq::service':
      ensure => $imq_state_real
    }

    Class['sunappserver::config::imq'] ~> Class['sunappserver::imq::service']

    if ( $use_default_domain == true ) {
      Class['sunappserver::imq::service'] ~> Class['sunappserver::service']
    }
  } else {

    class { 'sunappserver::config::imq':
      ensure => 'absent'
    }
  }

  Class['sunappserver::package'] -> Class['sunappserver::config']
  Class['sunappserver::config'] -> Class['sunappserver']

}
