class gradle::install (
  $system_packages = ["openjdk-6-jdk", "maven2"],
){

  # webupdat8 PPA to support oracle-* packages (https://launchpad.net/~webupd8team/+archive/java)
  apt::ppa {"ppa:webupd8team/java":}
  
  # install runtime and tools
  package { $system_packages:
    ensure => present,	 # stability over new hotness
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
