class ruby::install {
  
  # install base ruby packages
  $packages = [ "build-essential" ]
  package { $packages:
    ensure => present,
  }
  
  exec {"install-system-bundler":
    command => "/usr/bin/gem install bundler --no-ri --no-rdoc --force",
    path => "/bin:/usr/bin",
    user => "root",
    group => "root",
    unless => "/usr/bin/gem list | grep bundler",
  }

  # create define for upstart template installation
  define upstart_template () {
    file { "/var/cache/opdemand/$name":
      source => "puppet:///modules/ruby/$name",
    }
  }

  # install upstart templates
  $templates = [ "master.conf.erb", "process_master.conf.erb", "process.conf.erb"]
  upstart_template { $templates: }
  
}
