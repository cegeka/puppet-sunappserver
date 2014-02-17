class sunappserver::config (
    $runas               = 'appserv',
    $appserv_installroot = "${sunappserver::params::appserv_installroot}"
  ) {

  if ! defined(Class['sunappserver::params']) {
    fail('You must include the sunappserver::params class before using this class')
  }

  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${runas} ${appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${appserv_installroot} | grep ${runas}`",
  }
}
