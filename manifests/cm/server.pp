# == Class: cloudera::cm::server
#
# This class handles installing and configuring the Cloudera Manager Server.
#
# === Parameters:
#
# [*db_type*]
#   Which type of database to use for Cloudera Manager.  Valid options are
#   embedded, mysql, oracle, or postgresql.
#   Default: embedded
#
# === Actions:
#
#
# === Requires:
#
#   Package['mysql-connector-java']
#   Package['oracle-connector-java']
#   Package['postgresql-java']
#   Package['jdk-sun']
#
# === Sample Usage:
#
#   class { 'cloudera::cm::server':
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
class cloudera::cm::server (
  $database_name  = 'scm',
  $username       = 'scm',
  $password       = 'scm',
  $db_host        = 'localhost',
  $db_port        = '3306',
  $db_user        = 'root',
  $db_pass        = '',
  $db_type        = 'embedded',
  $ensure         = $cloudera::params::ensure,
  $autoupgrade    = $cloudera::params::autoupgrade,
  $service_ensure = $cloudera::params::service_ensure,
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  # Validate our regular expressions
  $states = [ '^embedded$', '^mysql$','^oracle$','^postgresql$' ]
  validate_re($db_type, $states, '$db_type must be either embedded, mysql, oracle, or postgresql.')

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      if $service_ensure in [ running, stopped ] {
        $service_ensure_real = $service_ensure
        $service_enable = true
      } else {
        fail('service_ensure parameter must be running or stopped')
      }
      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $service_ensure_real = 'stopped'
      $service_enable = false
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  if $db_type != 'embedded' {
    $file_content = template('cloudera/db.properties.erb')
  }

  package { 'cloudera-manager-server':
    ensure  => $package_ensure,
  }

#  package { 'cloudera-manager-daemons':
#    ensure => $package_ensure,
#  }

  file { '/etc/cloudera-scm-server/db.properties':
    ensure  => $file_ensure,
    path    => '/etc/cloudera-scm-server/db.properties',
    content => $file_content,
    require => Package['cloudera-manager-server'],
    notify  => Service['cloudera-scm-server'],
  }

  service { 'cloudera-scm-server':
    ensure     => $service_ensure_real,
    enable     => $service_enable,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['cloudera-manager-server'],
  }

  @exec { 'scm_prepare_database':
    command => "/usr/share/cmf/schema/scm_prepare_database.sh ${db_type} ${scmopts} --user=${db_user} --password=${db_pass} ${database_name} ${username} ${password} && touch /etc/cloudera-manager-server/.scm_prepare_database",
    creates => '/etc/cloudera-manager-server/.scm_prepare_database',
    require => $scm_prepare_database_require,
  }

  case $db_type {
    'embedded': {
      package { 'cloudera-manager-server-db':
        ensure  => $package_ensure,
      }

      exec { 'cloudera-manager-server-db':
        command => '/sbin/service cloudera-scm-server-db initdb',
        creates => '/etc/cloudera-scm-server/db.mgmt.properties',
        require => Package['cloudera-manager-server-db'],
      }

      service { 'cloudera-scm-server-db':
        ensure     => $service_ensure_real,
        enable     => $service_enable,
        hasrestart => true,
        hasstatus  => true,
        require    => Exec['cloudera-manager-server-db'],
        before     => Service['cloudera-scm-server'],
      }
    }
    'mysql': {
      if ( $db_host != 'localhost' ) and ( $db_host != $fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${fqdn}"
        $scm_prepare_database_require = [ Package['cloudera-manager-server'], Service['mysqld'], ]
      } else {
        #require mysql::server
        Class['mysql::server'] -> Exec['scm_prepare_database']
        $scm_prepare_database_require = Package['cloudera-manager-server']
      }

      if ! defined(Class['mysql::java']) {
        class { 'mysql::java': }
      }
      realize Exec['scm_prepare_database']
      Class['mysql::java'] -> Exec['scm_prepare_database']
    }
    'oracle': {
      if ( $db_host != 'localhost' ) and ( $db_host != $fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${fqdn}"
        #$scm_prepare_database_require = [ Package['cloudera-manager-server'], Service['oracle'], ]
        $scm_prepare_database_require = Package['cloudera-manager-server']
      } else {
        #require oracle::server
        #Class['oracle::server'] -> Service['cloudera-scm-server']
        $scm_prepare_database_require = Package['cloudera-manager-server']
      }

      # TODO: find a Class['oracle::java']
      #if ! defined(Class['oracle::java']) {
      #  class { 'oracle::java': }
      #}
      realize Exec['scm_prepare_database']
      #Class['oracle::java'] -> Exec['scm_prepare_database']
    }
    'postgresql': {
      if ( $db_host != 'localhost' ) and ( $db_host != $fqdn ) {
        # Set the commandline options to connect to a remote database.
        $scmopts = "--host=${db_host} --port=${db_port} --scm-host=${fqdn}"
        $scm_prepare_database_require = [ Package['cloudera-manager-server'], Service['postgresqld'], ]
      } else {
        #require postgresql::server
        Class['postgresql::server'] -> Service['cloudera-scm-server']
        $scm_prepare_database_require = Package['cloudera-manager-server']
      }

      if ! defined(Class['postgresql::java']) {
        class { 'postgresql::java': }
      }
      realize Exec['scm_prepare_database']
      Class['postgresql::java'] -> Exec['scm_prepare_database']
    }
    default: { }
  }
}
