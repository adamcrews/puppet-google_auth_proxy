# == Class google_auth_proxy::config
#
# This class is called from google_auth_proxy
#
class google_auth_proxy::config {

  file { $google_auth_proxy::config_file:
    ensure  => file,
    owner   => 'root',
    group   => $google_auth_proxy::auth_group,
    mode    => '0640',
    content => template("${module_name}/google_auth_proxy.cfg.erb"),
  }

}
