# == Class: cloudera::scm_server
#
# This class handles installing and configuring the Cloudera Manager Server.
#
# === Parameters:
#
# === Actions:
#
#
# === Requires:
#
#   Package['mysql-connector-java']
#   Package['jdk-sun']
#
# === Sample Usage:
#
#   class { 'cloudera::scm_server':
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
class cloudera::scm_server (
  $user          = 'root',
  $passwd        = 'password',
  $db_host       = 'localhost',
  $db_port       = '',
  $db_name       = 'cmf',
  $db_user       = 'cmf',
  $db_pass       = '',
  $use_mysql     = false,
  $use_postgreql = false,
  $use_embdb     = true
) inherits cloudera::params {
  package { 'cloudera-manager-server':
    ensure  => 'present',
  }

  file { '/etc/cloudera-scm-server/db.properties':
    path    => '/etc/cloudera-scm-server/db.properties',
    content => $use_embdb ? {
      true  => undef,
      false => template('cloudera/db.properties.erb'),
    },
    require => Package['cloudera-manager-server'],
  }

  service { 'cloudera-scm-server':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['cloudera-manager-server'],
  }

  if $use_embdb {
    package { 'cloudera-manager-server-db':
      ensure  => 'present',
    }

    exec { 'cloudera-manager-server-db':
      command => '/sbin/service cloudera-scm-server-db initdb',
      creates => '/etc/cloudera-scm-server/db.mgmt.properties',
      require => Package['cloudera-manager-server-db'],
    }

    service { 'cloudera-scm-server-db':
      ensure     => 'running',
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      before     => Service['cloudera-scm-server'],
      require    => Package['cloudera-manager-server-db'],
    }
  }
}
