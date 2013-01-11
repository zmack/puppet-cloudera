class cloudera::cdh::bigtop {
  package { 'bigtop-jsvc':
    ensure => 'present',
  }

  package { 'bigtop-tomcat':
    ensure => 'present',
  }

  package { 'bigtop-utils':
    ensure => 'present',
  }
}
