# == Class: cloudera::java
#
# This class handles installing Oracle JDK as shipped by Cloudera.
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
#   class { 'cloudera::java': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::java (
  $ensure      = $cloudera::params::ensure,
  $autoupgrade = $cloudera::params::autoupgrade,
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)

  case $ensure {
    /(present)/: {
      if $autoupgrade == true {
        $package_ensure = 'latest'
      } else {
        $package_ensure = 'present'
      }

      $file_ensure = 'present'
    }
    /(absent)/: {
      $package_ensure = 'absent'
      $file_ensure = 'absent'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  package { 'jdk':
    ensure => $package_ensure,
  }

  file { 'java-profile.d':
    ensure  => $file_ensure,
    path    => '/etc/profile.d/java.sh',
    content => template('cloudera/java.sh.erb'),
  }
}
