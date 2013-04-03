class ruby::rake (
  $username = "ubuntu",
  $group = "ubuntu",
  $home = "/home/ubuntu",
  $repository_path = "/home/ubuntu/repo",
){

	require ruby::rbenv
	
	exec { "rake-db-create":
	  command => "rake db:create:all",
	  path => "$home/bin:$home/.rbenv/bin:$home/.rbenv/shims:/bin:/usr/bin",
      environment => "HOME=$home",
	  user => $username,
	  group => $group,
	  cwd => $repository_path,
	  subscribe => Vcsrepo[$repository_path],
	  onlyif => "test -e $repository_path/Rakefile",
	}

	exec { "rake-db-migrate":
	  command => "rake db:migrate",
	  path => "$home/bin:$home/.rbenv/bin:$home/.rbenv/shims:/bin:/usr/bin",
      environment => "HOME=$home",
	  user => $username,
	  group => $group,
	  cwd => $repository_path,
	  require => Exec["rake-db-create"],
	  subscribe => Vcsrepo[$repository_path],
	  onlyif => "test -e $repository_path/Rakefile",
	}
	
}