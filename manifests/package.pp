class sunappserver::package($ensure=undef, $appserver_version=undef) {

  include sunappserver::params

  if ! ($ensure in ['present', 'absent']) {
    fail('Class[sunappserver::package]: ensure parameter must be present or absent')
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

  package { 'sunappserver':
    ensure   => $real_appserver_ensure,
  }

}
