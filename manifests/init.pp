# == Class: google_auth_proxy
#
# Full description of class google_auth_proxy here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class google_auth_proxy (

  # These parameters are used to configure the puppet module
  $package_version            = $google_auth_proxy::params::version,

  $download_url               = $google_auth_proxy::params::download_url,
  $install_base               = $google_auth_proxy::params::install_base,
  $bin_file                   = $google_auth_proxy::params::bin_file,

  $service_manage             = $google_auth_proxy::params::service_manage,
  $service_name               = $google_auth_proxy::params::service_name,
  $init_script                = $google_auth_proxy::params::init_script,

  $user_manage                = $google_auth_proxy::params::user_manage,
  $auth_user                  = $google_auth_proxy::params::auth_user,
  $auth_group                 = $google_auth_proxy::params::auth_group,

  $config_file                = $google_auth_proxy::params::config_file,

  # These parameters are used to configure the actual app
  $authenticated_emails_file  = undef,
  $client_id,
  $client_secret,
  $cookie_domain              = undef,
  $cookie_expire              = '168h',
  $cookie_secret              = undef,
  $cookie_https_only          = true,
  $http_address               = '127.0.0.1',
  $http_port                  = '4180',
  $pass_basic_auth            = true,
  $redirect_url               = undef,
  $upstreams,
  $google_apps_domain         = undef,

) inherits google_auth_proxy::params {

  # validate parameters here
  if $::architecture != 'x86_64' {
    fail("ERROR: ${::architecture} is not supported, only x86_64")
  }

  validate_string($package_version)

  validate_string($download_url)
  validate_absolute_path($install_base)
  validate_string($bin_file)

  validate_bool($service_manage)
  validate_string($service_name)
  validate_absolute_path($init_script)

  validate_bool($user_manage)
  validate_string($auth_user)
  validate_string($auth_group)

  validate_absolute_path($config_file)

  if $authenticated_emails_file {
    validate_absolute_path($authenticated_emails_file)
  }

  unless is_string($client_id) {
    fail ("ERROR: You must pass Google OAuth Client ID (client_id): ie \"123456.apps.googleusercontent.com\"")
  }

  unless is_string($client_secret) {
    fail ('ERROR: You must pass the Google OAuth Client Secret (client_secret)')
  }

  if $cookie_domain {
    unless is_domain_name($cookie_domain) {
      fail ("ERROR: Cookie domain does not look like a domain. (passed: ${cookie_domain})")
    }
  }

  validate_string($cookie_expire)
  validate_string($cookie_secret)

  validate_bool($cookie_https_only)

  unless is_ip_address($http_address) {
    fail("ERROR: \$http_address does not appear to be an IP address. (passed: ${http_address})")
  }

  unless ( is_integer($http_port) and ($http_port < 65535) and ($http_port > 0)) {
    fail("ERROR: \$http_port does not appear to be a valid port number. (passed: ${http_port})")
  }

  validate_bool($pass_basic_auth)
  validate_string($redirect_url)

  if $upstreams {
    unless is_array($upstreams) {
      fail("ERROR: \$upstreams does not appear to be a valid array. (passed: ${upstreams})")
    }
  }

  # This would be really cool to be able to loop through each element of 
  # the array and check every entry with the is_domain_name() function, 
  # but um... yeah declarative dsl....
  if $google_apps_domain {
    unless is_array($google_apps_domain) {
      fail("ERROR: \$google_apps_domain does not appear to be a valid array. (passed: ${google_apps_domain})")
    }
  }
  # wow, that's a lot of validation

  class { 'google_auth_proxy::install': } ->
  class { 'google_auth_proxy::config': } ~>
  class { 'google_auth_proxy::service': } ->
  Class['google_auth_proxy']

}
