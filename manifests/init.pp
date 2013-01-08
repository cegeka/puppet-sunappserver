#
# Class: sunappserver
#
# This module manages sunappserver.
# Include it to install the Sun Java System Application Server
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
# [*appserver_status*] The status of the Application Server (default: 'running').
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
# [*imq_status*] The status of the IMQ Message Broker (default: 'running').
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
  #$appserver_status='running',
  $service_state='running',
  $runas='appserv',
  $imq_type='remote',
  #$imq_status='running',
  $imq_home='/opt/appserver/imq',
  $imq_port='7676',
) {

  include stdlib

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
      fail('Class[sunappserver]: parameter imq_type must be "remote" or "embedded"')
    }
  }

  case $::osfamily {
    'RedHat': {
      include sunappserver::params

      class { 'sunappserver::package': }
      class { 'sunappserver::config': }
      class { 'sunappserver::service': }

      Class['sunappserver::package'] -> Class['sunappserver::config']
      Class['sunappserver::config'] ~> Class['sunappserver::service']
      Class['sunappserver::config'] -> Class['sunappserver']
    }
    default: {
      fail("Class[sunappserver]: osfamily ${::osfamily} is not supported")
    }
  }

  #case $::operatingsystem {
  #    redhat, centos: { include sunappserver::redhat }
  #    debian, ubuntu: { include sunappserver::debian }
  #    default: { fail("operatingsystem ${::operatingsystem} is not supported") }
  #}

}
