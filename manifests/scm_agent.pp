# == Class: cloudera::scm_agent
#
# This class handles installing and configuring the Cloudera Manager Agent.
#
# === Parameters:
#
# [*server_host*]
#   Hostname of the Cloudera Manager server.
#   Default: localhost
#
# [*server_port*]
#   Port to which the Cloudera Manager server is listening.
#   Default: 7182
#
# === Actions:
#
#
# === Requires:
#
#   Package['jdk-sun']
#
# === Sample Usage:
#
#   class { 'cloudera::scm_agent':
#     server_host => 'smhost.localdomain',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::scm_agent (
  $server_host = 'localhost',
  $server_port = '7182'
) {
  package { 'cloudera-manager-agent':
    ensure => 'present',
  }

  file { 'scm-config.ini':
    ensure  => 'present',
    path    => '/etc/cloudera-scm-agent/config.ini',
    content => template('cloudera/scm-config.ini.erb'),
    require => Package['cloudera-manager-agent'],
    notify  => Service['cloudera-scm-agent'],
  }

  service { 'cloudera-scm-agent':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['cloudera-manager-agent'],
  }
}
