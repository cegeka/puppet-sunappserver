class sunappserver::service (
  $ensure = 'running',
  $enable = true
  ) {

  case $ensure {
    'running', 'stopped': {
      service { 'sunappserver':
        ensure    => $ensure,
        enable    => $enable,
        hasstatus => true
      }
    }
    'unmanaged': {
      notice('Class[sunappserver::service]: service is currently not being managed')
    }
    default: {
      fail('Class[sunappserver::service]: parameter ensure must be running or stopped')
    }
  }
}
