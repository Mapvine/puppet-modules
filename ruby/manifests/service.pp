class ruby::service (
  $app_name = "ruby",
){

  service { $app_name:
    ensure => running,
    provider => upstart,
    require => [ Class[Ruby::Install], Class[Ruby::Config], Class[Ruby::Rbenv] ],
  }

}
