#
# Class: sunappserver
#
# This module manages sunappserver.
# Include it to install the Sun Java System Application Server
#
# === Parameters:
#
# [*appserver_version*] The version of the Application Server (default: 'latest').
#                       - Required: no
#                       - Content: String
#
# [*ensure*] The desired state for the package (default: 'present').
#            - Required: no
#            - Content: 'present' | 'absent'
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
  $appserver_status='running',
  $runas='appserv',
  $imq_status='running',
  $imq_home='/opt/appserver/imq',
  $imq_port='7676',
) {

  include sunappserver::params

  case $::operatingsystem {
      redhat, centos: { include sunappserver::redhat }
      debian, ubuntu: { include sunappserver::debian }
      default: { fail("operatingsystem ${::operatingsystem} is not supported") }
  }

}
