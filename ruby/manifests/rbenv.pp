class ruby::rbenv (
  $username = "ubuntu",
  $group = "ubuntu",
  $home = "/home/ubuntu",  
  $repository_path = "/home/ubuntu/repo",
  $ruby_version = "",
){

  # install base rbenv
  rbenv::install { $username:
    group => $group,
    home => $home,
  }
  
  # see if we need to compile a custom ruby version
  if $ruby_version {
      notice("using requested ruby version: $ruby_version")
	  rbenv::compile { $ruby_version:
	    user => $username,
	    home => $home,
	    global => true,
	    require => Rbenv::Install[$username];
	  }
	  $bundle_requires = [ Rbenv::Compile[$ruby_version] ]
  } else {
  	notice("using system ruby")
    $bundle_requires = [ Rbenv::Install[$username] ]
  }
    
  # bundle install latest dependencies
  exec { "bundle":
    command => "bundle --deployment --path=vendor/bundle --binstubs=bin",
    timeout => 0,
    # show output to find missing system libraries
    logoutput => true,
    path => "$home/bin:$home/.rbenv/bin:$home/.rbenv/shims:/bin:/usr/bin",
    environment => "HOME=$home",
    cwd => $repository_path,
    user => $username,
    group => $group,
    subscribe => Vcsrepo[$repository_path],
    require => $bundle_requires,
  }

  # rehash after calling bundle
  exec { "rehash":
    command => "rbenv rehash",
    environment => "HOME=$home",
    path => "$home/.rbenv/bin:$home/.rbenv/shims:/bin:/usr/bin",
    cwd => $repository_path,
    user => $username,
    group => $group,
    subscribe => Exec["bundle"],
  }  
}