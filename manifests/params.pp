class sunappserver::params {

  case $osfamily {
    'RedHat': {
      $appserv_installroot = '/opt/appserver'
      $imq_port            = '7676'
    }
    default: {
      fail("Class[sunappserver::params]: osfamily ${::osfamily} is not supported")
    }
  }
}
