class gradle::install (
  $system_packages = [],
){
  
  # install runtime and tools
  $packages = [ "openjdk-6-jdk", "maven2" ]
  package { $packages:
    ensure => present,	 # stability over new hotness
  }
  
  # install provided system packages
  package { $system_packages:
    ensure => latest, 	 # stability over new hotness
  }

  # create define for upstart template installation
  define upstart_template () {
    file { "/var/cache/opdemand/$name":
      source => "puppet:///modules/jetty/$name",
    }
  }

  # install upstart templates
  $templates = [ "master.conf.erb", "process_master.conf.erb", "process.conf.erb"]
  upstart_template { $templates: }
  
}
