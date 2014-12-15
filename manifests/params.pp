# == Class google_auth_proxy::params
#
# This class is meant to be called from google_auth_proxy
# It sets variables according to platform
#
class google_auth_proxy::params {
  $platform = downcase($::kernel)

  $version        = '1.0'
  $download_url   = "https://github.com/bitly/google_auth_proxy/releases/download/v${version}/google_auth_proxy-${version}.${platform}-amd64.go1.3.tar.gz"
  $install_base   = '/usr/local/google_auth_proxy'
  $bin_file       = "${install_base}/google_auth_proxy-${version}.${platform}-amd64.go1.3/google_auth_proxy"
  $config_file    = '/etc/google_auth_proxy.cfg'

  $service_name   = 'google_auth_proxy'
  $service_manage = true

  $user_manage    = true
  $auth_user      = 'gauth'
  $auth_group     = 'gauth'

  case $::osfamily {
    'Debian': { $init_script = "/etc/init.d/${service_name}" }
    'RedHat': { $init_script = "/etc/init.d/${service_name}" }
    'Darwin': { $init_script = "/tmp/${service_name}.init" }
    default:  { fail("ERROR: ${::osfamily} is not supported") }
  }

}
