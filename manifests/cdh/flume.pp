class cloudera::cdh::flume {
  package { 'flume-ng':
    ensure => 'present',
  }

  service { 'flume-ng':
    ensure     => 'running',
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    require    => Package['flume-ng'],
  }
}
