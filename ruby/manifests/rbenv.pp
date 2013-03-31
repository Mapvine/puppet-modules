class ruby::rbenv (
  $username = "ubuntu",
  $group = "ubuntu",
  $home = "/home/ubuntu",  
  $repository_path = "/home/ubuntu/repo",
){

  # require the repository so ~/repo/.ruby-version exists when evaluated
  require opdemand::app::repository
  
  # install base rbenv
  rbenv::install { $username:
    group => $group,
    home => $home,
  }
  
  # check for a requested ruby version in the repo
  $ruby_string = file("$repository_path/.ruby-version", "/dev/null")
  $requested_ruby = inline_template("<%= @ruby_string.chomp %>")   
  if $requested_ruby {
      notice("using requested ruby version: $requested_ruby")
	  rbenv::compile { "$requested_ruby":
	    user => $username,
	    home => $home,
	    global => true,
	    require => Rbenv::Install[$username];
	  }
	  # rehash after compile
	  exec { "rehash-after-compile":
	    command => "rbenv rehash",
	    path => "$home/.rbenv/bin:${home}/.rbenv/shims:/bin:/usr/bin",
	    cwd => $repository_path,
	    user => $username,
	    group => $group,
	    require => Rbenv::Compile[$requested_ruby],
	  }	  
	  $bundle_requires = [ Rbenv::Compile["$requested_ruby"], Exec["rehash-after-compile" ] ]
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