class gradle::service (
  $app_name = "gradle",
){

  service { $app_name:
    ensure => running,
    provider => upstart,
    require => [ Class[Gradle::Install], Class[Gradle::Config], Class[Gradle::Gradlew] ],
  }

}
