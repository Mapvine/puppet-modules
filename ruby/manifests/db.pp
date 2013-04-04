class ruby::db (
  $username = "ubuntu",
  $group = "ubuntu",
  $home = "/home/ubuntu",
  $repository_path = "/home/ubuntu/repo",
  # database settings
  $database_type = "sqlite3",
  $database_encoding = "",
  $database_name = "db/production.sqlite3",
  $database_pool = "",
  $database_username = "",
  $database_password = "",
  $database_host = "",
  $database_port = "",
  $database_timeout = "",
  $database_reconnect = "",
){

  file {"$repository_path/config/database.yml":
    ensure => file,
    owner => $username,
    group => $group,
    content => template("ruby/database.yml.erb"),
    require => Vcsrepo[$repository_path], 
  }
  
}