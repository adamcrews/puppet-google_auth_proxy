# == Class google_auth_proxy::service
#
# This class is meant to be called from google_auth_proxy
# It ensure the service is running
#
class google_auth_proxy::service {

  if $google_auth_proxy::service_manage == true {
    service { $google_auth_proxy::service_name:
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
