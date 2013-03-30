class ruby::rbenv (
  $username = "ubuntu",
  $group = "ubuntu",
  $home = "/home/ubuntu",  
  $repository_path = "/home/ubuntu/repo",
){

  # install base rbenv
  rbenv::install { $username:
    group => $group,
    home => $home,
  }
  
  # check for a requested ruby version in the repo
  $ruby_string = file("$repository_path/.ruby_version", "/dev/null")
  $requested_ruby = inline_template("<%= @ruby_string.chomp %>")   
  if $requested_ruby {
	  rbenv::compile { "$requested_ruby":
	    user => $username,
	    home => $home,
	    global => true,
	  }
	  $bundle_requires = [ Rbenv::Compile["$requested_ruby"] ]
  } else {
    $bundle_requires = []
  }
    
  # bundle install latest dependencies
  exec { "bundle":
    command => "bundle --deployment --path=vendor/bundle --binstubs=bin",
    path => "${home}/bin:${home}/.rbenv/shims:/bin:/usr/bin",
    cwd => $repository_path,
    user => $username,
    group => $group,
    subscribe => Vcsrepo[$repository_path],
    require => $bundle_requires,
  }

  # rehash after calling bundle
  exec { "rehash":
    command => "rbenv rehash",
    path => "$home/.rbenv/bin:${home}/.rbenv/shims:/bin:/usr/bin",
    cwd => $repository_path,
    user => $username,
    group => $group,
    subscribe => Exec["bundle"],
  }  
}