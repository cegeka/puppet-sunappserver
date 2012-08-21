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
class sunappserver($appserver_version=undef, $ensure='present') {

  if $ensure in [present, absent] {
  } else {
    fail('Sunappserver: ensure parameter must be present or absent')
  }

  if $ensure == 'absent' {
    $real_appserver_ensure = $ensure
  } else {
    if ! $appserver_version {
      $real_appserver_ensure = 'latest'
    } else {
      $real_appserver_ensure = $appserver_version
    }
  }

  case $::operatingsystem {
      redhat, centos: { include sunappserver::redhat }
      debian, ubuntu: { include sunappserver::debian }
      default: { fail("operatingsystem ${::operatingsystem} is not supported") }
  }

}
