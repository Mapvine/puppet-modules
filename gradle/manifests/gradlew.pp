class gradle::gradelw (
  $repository_path = "/home/ubuntu/repo",
){
  
  # run `gradle stage` if `gradelw` exists and is executable
  exec { "stage":
    command => "$repository_path/gradlew",
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