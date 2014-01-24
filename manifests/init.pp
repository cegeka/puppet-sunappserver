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
# [*ensure*] The desired state for the package (default: 'present').
#            - Required: no
#            - Content: 'present' | 'absent'
#
# [*appserver_version*] The version of the Application Server (default: 'latest').
#                       - Required: no
#                       - Content: String
#
# [*service_state*] The status of the Application Server (default: 'running').
#                       - Required: no
#                       - Content: String
#
# [*runas*] The user under which the Application Server process is running (default: 'appserv').
#                       - Required: no
#                       - Content: String
#
# [*imq_type*] The type of the IMQ Message Broker (default: 'remote').
#                       - Required: no
#                       - Content: String
#
# [*imq_home*] The home of the IMQ Message Broker (default: '/opt/appserver/imq').
#                       - Required: no
#                       - Content: String
#
# [*imq_port*] The port of the IMQ Message Broker (default: '7676').
#                       - Required: no
#                       - Content: String
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
class sunappserver(
  $ensure='present',
  $appserver_version=undef,
  $service_state='running',
  $runas='appserv',
  $imq_type='remote',
  $imq_home="${sunappserver::params::appserv_installroot}/imq",
  $imq_port='7676',
) inherits sunappserver::params {

  include stdlib

  case $service_state {
    'running', 'stopped': { $service_state_real = $service_state }
    default: {
      fail('Class[sunappserver]: parameter service_state must be running or stopped')
    }
  }

  case $imq_type {
    'remote': {
      $imq_type_real = upcase($imq_type)
      $imq_state = $service_state
    }
    'embedded': {
      $imq_type_real = upcase($imq_type)
      $imq_state = 'stopped'
    }
    default: {
      fail('Class[sunappserver]: parameter imq_type must be remote or embedded')
    }
  }

  case $::osfamily {
    'RedHat': {
      class { 'sunappserver::package':
        ensure            => $ensure,
        appserver_version => $appserver_version
      }
      class { 'sunappserver::config':
        runas    => $runas,
        imq_type => $imq_type_real,
        imq_home => $imq_home
      }
      class { 'sunappserver::service':
        service_state => $service_state_real,
        imq_type      => $imq_type_real,
        imq_state     => $imq_state
      }

      Class['sunappserver::package'] -> Class['sunappserver::config']
      Class['sunappserver::config'] ~> Class['sunappserver::service']
      Class['sunappserver::config'] -> Class['sunappserver']
    }
    default: {
      fail("Class[sunappserver]: osfamily ${::osfamily} is not supported")
    }
  }

}
