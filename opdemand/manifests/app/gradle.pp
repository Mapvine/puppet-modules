class opdemand::app::gradle {

  require opdemand::common
  require opdemand::app::repository

  class {"gradle::config":
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
    concurrency => hiera("APPLICATION_CONCURRENCY", "web=1"),
    app_name => hiera("APPLICATION_NAME", "gradle"),
    port => hiera("APPLICATION_PORT", 5000),
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
    home => hiera("APPLICATION_HOME", "/home/ubuntu"),
    envvars => hiera("GRADLE_ENVVARS", {}),
  }

  class {"gradle::install":
    system_packages => hiera("GRADLE_SYSTEM_PACKAGES", []),
  }
  
  class {"gradle::gradlew":
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
  }

  class {"gradle::service":
    app_name => hiera("APPLICATION_NAME", "app"),
  }
  
}
