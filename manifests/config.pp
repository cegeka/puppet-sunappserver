class sunappserver::config (
    $ensure              = 'present',
    $runas               = 'appserv',
    $appserv_installroot = "${sunappserver::params::appserv_installroot}"
  ) {

  if ! defined(Class['sunappserver::params']) {
    fail('You must include the sunappserver::params class before using this class')
  }
  if ($ensure == present) {
  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${runas} ${appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${appserv_installroot} | grep ${runas}`",
  }

  file { "${appserv_installroot}/domains":
    ensure => 'directory',
    owner  => $runas,
    mode   => '0770'
  }
  }

}
