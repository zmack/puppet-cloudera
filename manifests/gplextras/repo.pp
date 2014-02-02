# == Class: cloudera::gplextras::repo
#
# This class handles installing the Cloudera GPL Extras software repositories.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*yumpath*]
#   The path to add to the $yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*version*]
#   The version of Cloudera GPL Extras to install.
#   Default: 4
#
# [*proxy*]
#   The URL to the proxy server for the YUM repositories.
#   Default: absent
#
# [*proxy_username*]
#   The username for the YUM proxy.
#   Default: absent
#
# [*proxy_password*]
#   The password for the YUM proxy.
#   Default: absent
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
#   class { 'cloudera::gplextras::repo':
#     version => '4.3.0',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2014 Mike Arnold, unless otherwise noted.
#
class cloudera::gplextras::repo (
  $ensure         = $cloudera::params::ensure,
  $yumserver      = $cloudera::params::cg_yumserver,
  $yumpath        = $cloudera::params::cg_yumpath,
  $version        = $cloudera::params::cg_version,
  $proxy          = $cloudera::params::proxy,
  $proxy_username = $cloudera::params::proxy_username,
  $proxy_password = $cloudera::params::proxy_password
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
      yumrepo { 'cloudera-gplextras4':
        descr          => 'Cloudera GPL Extras',
        enabled        => $enabled,
        gpgcheck       => 1,
        gpgkey         => "${yumserver}${yumpath}RPM-GPG-KEY-cloudera",
        baseurl        => "${yumserver}${yumpath}${version}/",
        priority       => $cloudera::params::yum_priority,
        protect        => $cloudera::params::yum_protect,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
      }

      file { '/etc/yum.repos.d/cloudera-gplextras4.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      Yumrepo['cloudera-gplextras4'] -> Package<|tag == 'cloudera-gplextras'|>
    }
    default: { }
  }
}
