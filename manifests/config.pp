class sunappserver::config (
    $runas               = 'appserv',
    $appserv_installroot = "${sunappserver::params::appserv_installroot}"
  ) {

  include sunappserver::params

  exec { 'modify-ownership-for-appserver-root' :
    command => "/bin/chown -R ${runas} ${appserv_installroot}",
    unless  => "/usr/bin/test `/usr/bin/stat -c %U ${appserv_installroot} | grep ${runas}`",
  }
}
