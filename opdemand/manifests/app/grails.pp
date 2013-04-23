class opdemand::app::grails {

  require opdemand::common
  require opdemand::app::repository

  class {"grails::config":
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
    concurrency => hiera("APPLICATION_CONCURRENCY", "web=1"),
    app_name => hiera("APPLICATION_NAME", "grails"),
    port => hiera("APPLICATION_PORT", 5000),
    username => hiera("APPLICATION_USERNAME", "ubuntu"),
    group => hiera("APPLICATION_GROUP", "ubuntu"),
    home => hiera("APPLICATION_HOME", "/home/ubuntu"),
  }

  class {"grails::install":
    system_packages => hiera("GRAILS_SYSTEM_PACKAGES", []),
  }
  
  class {"grails::grailsw":
    repository_path => hiera("APPLICATION_REPOSITORY_PATH", "/home/ubuntu/repo"),
  }

  class {"grails::service":
    app_name => hiera("APPLICATION_NAME", "app"),
  }
  
}
