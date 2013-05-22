class nginx::config (
  $template_name = "mapvine",
  $public_root = "/home/ubuntu/repo/public",
  $server_name = $ec2_public_hostname,
  $nginx_port = 80,
  $app_name = "app",  
  $app_port = 5000,
  $app_listeners = 1,
){
  
  # install sites-enabled (skip sites-available for now)
  file {"/etc/nginx/sites-enabled/$app_name":
    ensure => file,    
    owner => "root",
    group => "root",
    mode => 0644,
    content => template("nginx/$template_name.conf.erb"),
    require => Class[Nginx::Install],
    notify => Service["nginx"],
  }

  # ensure default site is removed
  file {"/etc/nginx/sites-enabled/default":
    ensure => absent,
    require => Class[Nginx::Install],
  }

  # ensure legacy site is removed
  $legacy_name = hiera("APPLICATION_NAME", "nginx")
  file {"/etc/nginx/sites-enabled/$legacy_name":
    ensure => absent,
    require => Class[Nginx::Install],
  }
  
}
