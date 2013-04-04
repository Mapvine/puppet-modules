class opdemand::app::ruby {

  require opdemand::common
  require opdemand::app::repository

  class {"ruby::install":
    system_packages => hiera("RUBY_SYSTEM_PACKAGES", []),
  }
  
  class {"ruby::config":
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
    home => hiera("APPLICATION_HOME", "/home/ubuntu"),
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
    app_name => hiera("APPLICATION_NAME", "ruby"),
    port => hiera("APPLICATION_PORT", 5000),
    concurrency => hiera("APPLICATION_CONCURRENCY", "web=1"),    
  }

  class {"ruby::service":
    app_name => hiera("APPLICATION_NAME", "ruby"),
  }
  
  class {"ruby::rbenv":
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
    home => hiera("APPLICATION_HOME", "/home/ubuntu"),
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
    # pass requested ruby version through to rbenv
    ruby_version => hiera("RUBY_VERSION", ""),
  }
   
  class {"ruby::rake":
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
    home => hiera("APPLICATION_HOME", "/home/ubuntu"),
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
  }
  
  # parse database variables
  if hiera("POSTGRES_HOST", "") != "" {
    $init_db = true
    $database_type = "postgresql"
    $database_encoding = "unicode"
    $database_name = hiera("POSTGRES_DBNAME", "app")
    $database_host = hiera("POSTGRES_HOST", "")
    $database_port = hiera("POSTGRES_PORT", "")
    $database_username = hiera("POSTGRES_USERNAME", "")
    $database_password = hiera("POSTGRES_PASSWORD", "")
    # optional params
    $database_pool = hiera("POSTGRES_POOL", 5)
    $database_timeout = hiera("POSTGRES_TIMEOUT", 5000)
    $database_reconnect = hiera("POSTGRES_RECONNECT", true)
  } elsif hiera("MYSQL_HOST", "") != "" {
    $init_db = true
    $database_type = "mysql2"
    $database_encoding = "utf8"
    $database_name = hiera("MYSQL_DBNAME", "")
    $database_host = hiera("MYSQL_HOST", "")
    $database_port = hiera("MYSQL_PORT", "")
    $database_username = hiera("MYSQL_USERNAME", "")
    $database_password = hiera("MYSQL_PASSWORD", "")
    # optional params
    $database_pool = hiera("MYSQL_POOL", 5)
    $database_timeout = hiera("MYSQL_TIMEOUT", 5000)
    $database_reconnect = hiera("MYSQL_RECONNECT", true)
  } else {
    $init_db = false
  }
  
  if $init_db {
    class {"ruby::db":
      username => hiera("APPLICATION_USERNAME", "ubuntu"),
      group => hiera("APPLICATION_GROUP", "ubuntu"),
      home => hiera("APPLICATION_HOME", "/home/ubuntu"),
      repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
      # database settings
      database_type => $database_type,
      database_encoding => $database_encoding,
	  database_name => $database_name,
	  database_host => $database_host,
      database_port => $database_port,   
      database_username => $database_username,
      database_password => $database_password,
      database_pool => $database_pool,
      database_timeout => $database_timeout,
      database_reconnect => $database_reconnect,
    }
  }
  
}
