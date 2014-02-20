# == Class: cloudera::repo
#
# This class handles installing the Cloudera CDH and Impala software
# repositories.
#
# == DEPRECATED
# cloudera::repo has been split into cloudera::cdh::repo and
# cloudera::impala::repo. This backwards compatibility shim will be removed on
# 02 April 2014.
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
# [*ci_yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*ci_yumpath*]
#   The path to add to the $ci_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*ci_version*]
#   The version of Cloudera Impala to install.
#   Default: 1
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
#   class { 'cloudera::repo':
#     cdh_version => '4.1',
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
  $ensure         = $cloudera::params::ensure,
  $cdh_yumserver  = $cloudera::params::cdh_yumserver,
  $cdh_yumpath    = $cloudera::params::cdh_yumpath,
  $cdh_version    = $cloudera::params::cdh_version,
  $ci_yumserver   = $cloudera::params::ci_yumserver,
  $ci_yumpath     = $cloudera::params::ci_yumpath,
  $ci_version     = $cloudera::params::ci_version,
  $proxy          = $cloudera::params::proxy,
  $proxy_username = $cloudera::params::proxy_username,
  $proxy_password = $cloudera::params::proxy_password
) inherits cloudera::params {

  notify { 'cloudera::repo has been split into cloudera::cdh::repo and cloudera::impala::repo. This backwards compatibility shim will be removed on 02 April 2014.': }

  class { 'cloudera::cdh::repo':
    ensure         => $ensure,
    yumserver      => $cdh_yumserver,
    yumpath        => $cdh_yumpath,
    version        => $cdh_version,
    proxy          => $proxy,
    proxy_username => $proxy_username,
    proxy_password => $proxy_password,
  }
  class { 'cloudera::impala::repo':
    ensure         => $ensure,
    yumserver      => $ci_yumserver,
    yumpath        => $ci_yumpath,
    version        => $ci_version,
    proxy          => $proxy,
    proxy_username => $proxy_username,
    proxy_password => $proxy_password,
  }
}
