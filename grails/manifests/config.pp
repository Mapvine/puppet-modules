class grails::config (
  $username = "ubuntu",
  $group = "ubuntu",  
  $home = "/home/ubuntu",
  $repository_path = "/home/ubuntu/repo",
  $app_name = "grails",
  $port = 5000,
  $concurrency = "web=1",
  $env_path = "/var/cache/opdemand/inputs.sh",
  $envvars = {},
){

  # write out JAVA_HOME to system-wide profile
  file { "/etc/profile.d/java-home.sh":
    ensure => file,
    owner => "root",
    group => "root",
    source => "puppet:///modules/grails/java-home.sh",
    mode => 0755,
  }
  
  # write custom envvars to the file system
  $custom_env_path = "$home/.opdemand-grails"
  file { $custom_env_path:
    ensure => file,
    owner => $username,
    group => $group,
    content => template("grails/env.sh.erb"),
  }
  
  # rebuild upstart conf files
  exec {"rebuild-upstart":
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    cwd => $repository_path,
    command => "foreman export upstart /etc/init -a $app_name -u $username -e $env_path,$custom_env_path -t /var/cache/opdemand -p $port -c $concurrency",
    # rebuild on change of envvars or the repository itself
    subscribe => [ File[$env_path], File[$custom_env_path], Vcsrepo[$repository_path] ],
    notify => Service[$app_name],
    require => Class[Grails::Install],
  }

}