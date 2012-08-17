class sunappserver::redhat {

  package { 'sunappserver':
    ensure   => $sunappserver::real_appserver_ensure,
  }

}
