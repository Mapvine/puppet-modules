class gradle::install (
  $system_packages = ["openjdk-6-jdk", "maven2"],
){

  # webupdat8 PPA to support oracle-* packages (https://launchpad.net/~webupd8team/+archive/java)
  apt::ppa {"ppa:webupd8team/java":}
  
  # install debconf-utils if not defined already
  if ! defined(Package["debconf-utils"]) {
  	package { "debconf-utils":
  	  ensure => present,
  	}
  }
  
  # NOTICE: accept oracle licenses automatically
  exec {"oracle-license-accept":
    command => "echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections",
    provider => "shell",
    unless => "debconf-get-selections | grep shared/accepted-oracle-license-v1-1 | grep true",
    require => Package["debconf-utils"],
  }
  
  # install runtime and tools
  package { $system_packages:
    ensure => present,	 # stability over new hotness
    require => Exec["oracle-license-accept"],
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
