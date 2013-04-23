class grails::grailsw (
  $repository_path = "/home/ubuntu/repo",
  $username = "ubuntu",
  $group = "ubuntu",
){
  
  # write out a JAVA_HOME wrapper
  file {"$repository_path/javaw":
    ensure => file,
    owner => $username,
    group => $group,
    source => "puppet:///modules/grails/javaw",
    mode => 0755,
  }
  
  # run `grails compile` and `grails war`
  # only if `gradelw` exists and is executable
  
  exec { "compile":
    command => "$repository_path/javaw $repository_path/grailsw compile --non-interactive",
    # log raw output from shell command
    logoutput => true,
    cwd => $repository_path,
    path => ["$repository_path", "$repository_path/bin", "/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => [Class[Grails::Install], Class[Grails::Config] ],
    subscribe => Vcsrepo[$repository_path],
    # only if the script exists and is executable
    onlyif => "test -x $repository_path/grailsw",
  }

  exec { "war":
    command => "$repository_path/javaw $repository_path/grailsw war --non-interactive",
    # log raw output from shell command
    logoutput => true,
    cwd => $repository_path,
    path => ["$repository_path", "$repository_path/bin", "/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    user => $username,
    group => $group,
    require => [Class[Grails::Install], Class[Grails::Config], Exec["compile"] ],
    subscribe => Vcsrepo[$repository_path],
    # only if the script exists and is executable
    onlyif => "test -x $repository_path/grailsw",
  }
  
  # download jetty runner if necessary
  $jetty_runner_version = "8.1.10.v20130312"
  
  file {"$repository_path/server":
    owner => $username,
    group => $group,
    ensure => directory,
    mode => 0755,
  }
  
  exec {"download-jetty":
    user => $username,
    group => $group,
    provider => shell,
    command => "curl -fs http://s3pository.heroku.com/maven-central/org/mortbay/jetty/jetty-runner/$jetty_runner_version/jetty-runner-$jetty_runner_version.jar > server/jetty-runner.jar",
    unless => "test -e $repository_path/server/jetty-runner.jar",
    require => File["$repository_path/server"],
  }
    
}