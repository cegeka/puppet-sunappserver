class sunappserver::service($service_state=undef, $imq_state=undef) {

  include sunappserver::params

  service { 'sunappserver' :
    ensure    => $service_state,
    enable    => true,
    hasstatus => true
  }

  service { 'imq' :
    ensure    => $imq_state,
    enable    => true,
    hasstatus => true
  }

  case $service_state {
    'running': {
      Service['imq'] -> Service['sunappserver']
    }
    'stopped': {
      Service['sunappserver'] -> Service['imq']
    }
    default: { fail('Class[sunappserver::service]: parameter service_state must be running or stopped') }
  }

}
