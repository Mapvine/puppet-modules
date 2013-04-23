class gradle::gradlew (
  $repository_path = "/home/ubuntu/repo",
  $username = "ubuntu",
  $group = "ubuntu",
){

  # write out a JAVA_HOME wrapper
  file {"$repository_path/javaw":
    ensure => file,
    owner => $username,
    group => $group,
    source => "puppet:///modules/gradle/javaw",
    mode => 0755,
  }
  
  # run `gradle stage` if `gradelw` exists and is executable
  exec { "stage":
    command => "$repository_path/javaw $repository_path/gradlew stage",
    # log raw output from shell command
    logoutput => true,
    cwd => $repository_path,
    path => ["$repository_path", "$repository_path/bin", "/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => [Class[Gradle::Install], Class[Gradle::Config] ],
    subscribe => Vcsrepo[$repository_path],
    # only if the script exists and is executable
    onlyif => "test -x $repository_path/gradlew",
  }
  
}