class postgres::install {
  
  package { "postgresql":
    ensure => latest,
  }

  user { 'postgres':
    ensure => 'present',
    comment => 'PostgreSQL Server',
    managehome => true,
    password => '!!',
    require => Package["postgresql"],
  }

  group { 'postgres':
    ensure => 'present',
    require => Package["postgresql"],
  }
  
  file { '/var/log/puppet':
    ensure => directory,
  }
  
}
