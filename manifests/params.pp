class sunappserver::params {

  if $sunappserver::ensure in [present, absent] {
  } else {
    fail('Sunappserver: ensure parameter must be present or absent')
  }

  if $sunappserver::ensure == 'absent' {
    $real_appserver_ensure = $sunappserver::ensure
  } else {
    if ! $sunappserver::appserver_version {
      $real_appserver_ensure = 'latest'
    } else {
      $real_appserver_ensure = $sunappserver::appserver_version
    }
  }

  $appserv_installroot = '/opt/appserver'

}
