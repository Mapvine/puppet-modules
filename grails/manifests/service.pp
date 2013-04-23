class grails::service (
  $app_name = "grails",
){

  service { $app_name:
    ensure => running,
    provider => upstart,
    require => [ Class[Grails::Install], Class[Grails::Config], Class[Grails::Grailsw] ],
  }

}
