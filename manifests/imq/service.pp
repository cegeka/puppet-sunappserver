class sunappserver::imq::service(
    $ensure = 'running',
    $enable = true
  ) {

  case $ensure {
    'running', 'stopped': {

      service { 'imq':
        ensure    => $ensure,
        enable    => $enable,
        hasstatus => true
      }
    }
    default: {
      fail('Class[sunappserver::imq::service]: parameter ensure must be running or stopped')
    }
  }
}
