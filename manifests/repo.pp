# == Class: cloudera::repo
#
# This class handles installing the Cloudera software repositories.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*cdh_yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cdh_yumpath*]
#   The path to add to the $cdh_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cdh_version*]
#   The version of Cloudera's Distribution, including Apache Hadoop to install.
#   Default: 4
#
# [*cm_yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cm_yumpath*]
#   The path to add to the $cm_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cm_version*]
#   The version of Cloudera Manager to install.
#   Default: 4
#
# [*ci_yumserver*]
#   URI of the YUM server.
#   Default: http://beta.cloudera.com
#
# [*ci_yumpath*]
#   The path to add to the $ci_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_version*]
#   The version of Cloudera Impala to install.
#   Default: 0
#
# === Actions:
#
# Installs YUM repository configuration files.
#
# === Requires:
#
# Nothing.
#
# === Sample Usage:
#
#   class { 'cloudera::repo':
#     cdh_version => '4.1',
#     cm_version  => '4.1',
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
class cloudera::repo (
  $ensure        = $cloudera::params::ensure,
  $cdh_yumserver = $cloudera::params::cdh_yumserver,
  $cdh_yumpath   = $cloudera::params::cdh_yumpath,
  $cdh_version   = $cloudera::params::cdh_version,
  $cm_yumserver  = $cloudera::params::cm_yumserver,
  $cm_yumpath    = $cloudera::params::cm_yumpath,
  $cm_version    = $cloudera::params::cm_version,
  $ci_yumserver  = $cloudera::params::ci_yumserver,
  $ci_yumpath    = $cloudera::params::ci_yumpath,
  $ci_version    = $cloudera::params::ci_version,
) inherits cloudera::params {
  case $ensure {
    /(present)/: {
      $enabled = '1'
    }
    /(absent)/: {
      $enabled = '0'
    }
    default: {
      fail('ensure parameter must be present or absent')
    }
  }

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      yumrepo { 'cloudera-cdh4':
        descr    => 'Cloudera\'s Distribution for Hadoop, Version 4',
        enabled  => $enabled,
        gpgcheck => 1,
        gpgkey   => "${cdh_yumserver}${cdh_yumpath}RPM-GPG-KEY-cloudera",
        baseurl  => "${cdh_yumserver}${cdh_yumpath}${cdh_version}/",
        priority => $cloudera::params::yum_priority,
        protect  => $cloudera::params::yum_protect,
      }
      yumrepo { 'cloudera-manager':
        descr    => 'Cloudera Manager',
        enabled  => $enabled,
        gpgcheck => 1,
        gpgkey   => "${cm_yumserver}${cm_yumpath}RPM-GPG-KEY-cloudera",
        baseurl  => "${cm_yumserver}${cm_yumpath}${cm_version}/",
        priority => $cloudera::params::yum_priority,
        protect  => $cloudera::params::yum_protect,
      }
      yumrepo { 'cloudera-impala':
        descr    => 'Impala',
        enabled  => $enabled,
        gpgcheck => 1,
        gpgkey   => "${ci_yumserver}${ci_yumpath}RPM-GPG-KEY-cloudera",
        baseurl  => "${ci_yumserver}${ci_yumpath}${ci_version}/",
        priority => $cloudera::params::yum_priority,
        protect  => $cloudera::params::yum_protect,
      }
    }
    default: { }
  }
}
