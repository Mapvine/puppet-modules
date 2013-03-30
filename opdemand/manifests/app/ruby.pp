class opdemand::app::ruby {

  require opdemand::common
  require opdemand::app::repository

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
  }
      
  include ruby::install

}
