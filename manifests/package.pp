class sunappserver::package {

  include sunappserver::params

  package { 'sunappserver':
    ensure   => $sunappserver::real_appserver_ensure,
  }

}
