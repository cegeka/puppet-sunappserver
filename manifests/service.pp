class sunappserver::service {

  include sunappserver::params

  service { 'sunappserver' :
    ensure    => $sunappserver::service_state,
    enable    => true,
    hasstatus => true
  }

  service { 'imq' :
    ensure    => $sunappserver::imq_state,
    enable    => true,
    hasstatus => true
  }

  case $sunappserver::service_state {
    'running': {
      Service['imq'] -> Service['sunappserver']
    }
    'stopped': {
      Service['sunappserver'] -> Service['imq']
    }
    default: { fail('Class[sunappserver::service]: parameter service_state must be running or stopped') }
  }

}
