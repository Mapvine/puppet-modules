class ruby::config (
  $username = "ubuntu",
  $group = "ubuntu",  
  $home = "/home/ubuntu",
  $repository_path = "/home/ubuntu/repo",
  $app_name = "ruby",
  $port = 5000,
  $concurrency = "web=1",
  $env_path = "/var/cache/opdemand/inputs.json",
){
  
  # rebuild upstart conf files
  exec {"rebuild-upstart":
    path => ["/sbin", "/bin", "/usr/bin", "/usr/local/bin"],
    cwd => $repository_path,
    command => "foreman export upstart /etc/init -a $app_name -u $username -e $env_path -t /var/cache/opdemand -p $port -c $concurrency",
    # rebuild on change of inputs.sh or the vcsrepo
    subscribe => [ File[$env_path], Vcsrepo[$repository_path] ],
    # notify the service on change
    notify => Service[$app_name],
    require => Class[Ruby::Install],
  }

}