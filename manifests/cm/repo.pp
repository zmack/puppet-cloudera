# == Class: cloudera::cm::repo
#
# This class handles installing the Cloudera Manager software repositories.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
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
#   class { 'cloudera::cm::repo':
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
class cloudera::cm::repo (
  $ensure         = $cloudera::params::ensure,
  $cm_yumserver   = $cloudera::params::cm_yumserver,
  $cm_yumpath     = $cloudera::params::cm_yumpath,
  $cm_version     = $cloudera::params::cm_version,
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
      yumrepo { 'cloudera-manager':
        descr          => 'Cloudera Manager',
        enabled        => $enabled,
        gpgcheck       => 1,
        gpgkey         => "${cm_yumserver}${cm_yumpath}RPM-GPG-KEY-cloudera",
        baseurl        => "${cm_yumserver}${cm_yumpath}${cm_version}/",
        priority       => $cloudera::params::yum_priority,
        protect        => $cloudera::params::yum_protect,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
      }

      file { '/etc/yum.repos.d/cloudera-manager.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      Yumrepo['cloudera-manager'] -> Package<|tag == 'cloudera-manager'|>
    }
    'SLES': {
      zypprepo { 'cloudera-manager':
        descr       => 'Cloudera Manager',
        enabled     => $enabled,
        gpgcheck    => 1,
        gpgkey      => "${cm_yumserver}${cm_yumpath}RPM-GPG-KEY-cloudera",
        baseurl     => "${cm_yumserver}${cm_yumpath}${cm_version}/",
        priority    => $cloudera::params::yum_priority,
        autorefresh => 1,
        notify      => Exec['cloudera-import-gpgkey'],
      }

      file { '/etc/zypp/repos.d/cloudera-manager.repo':
        ensure => 'file',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      exec { 'cloudera-import-gpgkey':
        command     => "/bin/rpm --import ${cm_yumserver}${cm_yumpath}RPM-GPG-KEY-cloudera",
        #command     => '/usr/bin/zypper --quiet refresh --auto-agree-with-licenses --no-confirm --gpg-auto-import-keys',
        refreshonly => true,
      }

      Zypprepo['cloudera-manager'] -> Package<|tag == 'cloudera-manager'|>
    }
    default: { }
  }
}
