# == Class: cloudera::repo
#
# This class handles installing the Cloudera software repositories.
#
# === Parameters:
#
# [*yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cdh_yumpath*]
#   The path to add to the $yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cm_yumpath*]
#   The path to add to the $yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cdh_version*]
#   The version of Cloudera's Distribution, including Apache Hadoop to install.
#   Default: 4
#
# [*cm_version*]
#   The version of Cloudera Manager to install.
#   Default: 4
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
  $yumserver   = cloudera::params::yumserver,
  $cdh_yumpath = cloudera::params::cdh_yumpath,
  $cm_yumpath  = cloudera::params::cm_yumpath,
  $cdh_version = '4',
  $cm_version  = '4'
){
  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      yumrepo { 'cloudera-cdh4':
        descr    => 'Cloudera\'s Distribution for Hadoop, Version 4',
        enabled  => 1,
        gpgcheck => 1,
        gpgkey   => "${yumserver}${cdh_yumpath}/RPM-GPG-KEY-cloudera",
        baseurl  => "${yumserver}${cdh_yumpath}/${cdh_version}/",
      }
      yumrepo { 'cloudera-manager':
        descr    => 'Cloudera Manager',
        enabled  => 1,
        gpgcheck => 0,
        gpgkey   => "${yumserver}${cm_yumpath}/RPM-GPG-KEY-cloudera",
        baseurl  => "${yumserver}${cm_yumpath}/${cm_version}/",
      }
    }
    default: { }
  }
}
