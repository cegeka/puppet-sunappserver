class { 'sunappserver':
  ensure              => 'present',
  imq_status          => 'running',
  sunappserver_status => 'running',
}
