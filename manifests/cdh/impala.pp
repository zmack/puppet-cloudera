class cloudera::cdh::impala {
  package { 'impala':
    ensure => 'present',
  }

  package { 'impala-shell':
    ensure => 'present',
  }
}
