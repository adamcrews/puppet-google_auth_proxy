# == Class google_auth_proxy::install
#
class google_auth_proxy::install {

  file { $google_auth_proxy::install_base:
    ensure => directory,
    owner  => 'root',
    group  => $google_auth_proxy::auth_group,
    mode   => '0755',
  }

  staging::deploy { 'google_auth_proxy.tgz':
    source  => $google_auth_proxy::download_url,
    target  => $google_auth_proxy::install_base,
    creates => $google_auth_proxy::bin_file,
    user    => 'root',
    group   => $google_auth_proxy::auth_group,
  }

  if $google_auth_proxy::service_manage == true {
    file { $google_auth_proxy::init_script:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("google_auth_proxy/${::kernel}.init.erb"),
    }
  }

  if $google_auth_proxy::user_manage == true {
    group { $google_auth_proxy::auth_group:
      ensure => present,
      system => true,
    }
    user { $google_auth_proxy::auth_user:
      ensure => present,
      system => true,
      gid    => $google_auth_proxy::auth_group,
    }
  }
}
