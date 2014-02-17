# == Class: cloudera::params
#
# This class handles OS-specific configuration of the cloudera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::params {
  # Customize these values if you (for example) mirror public YUM repos to your
  # internal network.
  $yum_priority = '50'
  $yum_protect = '0'

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $cdh_yumserver = $::cloudera_cdh_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cdh_yumserver,
  }

  $cm_yumserver = $::cloudera_cm_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cm_yumserver,
  }

  $ci_yumserver = $::cloudera_ci_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_ci_yumserver,
  }

  $cs_yumserver = $::cloudera_cs_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cs_yumserver,
  }

  $cg_yumserver = $::cloudera_cg_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_cg_yumserver,
  }

  $cm_server_host = $::cloudera_cm_server_host ? {
    undef   => 'localhost',
    default => $::cloudera_cm_server_host,
  }

  $cm_server_port = $::cloudera_cm_server_port ? {
    undef   => '7182',
    default => $::cloudera_cm_server_port,
  }

  $verify_cert_file = $::cloudera_verify_cert_file ? {
    undef   => '/etc/pki/tls/certs/cloudera_manager.crt',
    default => $::cloudera_verify_cert_file,
  }

  $server_ca_file = $::cloudera_server_ca_file ? {
    undef   => '/etc/pki/tls/certs/cloudera_manager-ca.crt',
    default => $::cloudera_server_ca_file,
  }

  $server_cert_file = $::cloudera_server_cert_file ? {
    undef   => "/etc/pki/tls/certs/${::fqdn}-cloudera_manager.crt",
    default => $::cloudera_server_cert_file,
  }

  $server_key_file = $::cloudera_server_key_file ? {
    undef   => "/etc/pki/tls/private/${::fqdn}-cloudera_manager.key",
    default => $::cloudera_server_key_file,
  }

  $server_chain_file = $::cloudera_server_chain_file ? {
    undef   => undef,
    default => $::cloudera_server_chain_file,
  }

  $server_keypw = $::cloudera_server_keypw ? {
    undef   => undef,
    default => $::cloudera_server_keypw,
  }

  $oozie_ext = $::cloudera_oozie_ext ? {
    undef   => 'http://archive.cloudera.com/gplextras/misc/ext-2.2.zip',
    default => $::cloudera_oozie_ext,
  }

### The following parameters should not need to be changed.

  $ensure = $::cloudera_ensure ? {
    undef => 'present',
    default => $::cloudera_ensure,
  }

  $service_ensure = $::cloudera_service_ensure ? {
    undef => 'running',
    default => $::cloudera_service_ensure,
  }

  $proxy = $::cloudera_proxy ? {
    undef => 'absent',
    default => $::cloudera_proxy,
  }

  $proxy_username = $::cloudera_proxy_username ? {
    undef => 'absent',
    default => $::cloudera_proxy_username,
  }

  $proxy_password = $::cloudera_proxy_password ? {
    undef => 'absent',
    default => $::cloudera_proxy_password,
  }

  # Since the top scope variable could be a string (if from an ENC), we might
  # need to convert it to a boolean.
  $autoupgrade = $::cloudera_autoupgrade ? {
    undef => false,
    default => $::cloudera_autoupgrade,
  }
  if is_string($autoupgrade) {
    $safe_autoupgrade = str2bool($autoupgrade)
  } else {
    $safe_autoupgrade = $autoupgrade
  }

  $service_enable = $::cloudera_service_enable ? {
    undef => true,
    default => $::cloudera_service_enable,
  }
  if is_string($service_enable) {
    $safe_service_enable = str2bool($service_enable)
  } else {
    $safe_service_enable = $service_enable
  }

  $cm_use_tls = $::cloudera_cm_use_tls ? {
    undef => false,
    default => $::cloudera_cm_use_tls,
  }
  if is_string($cm_use_tls) {
    $safe_cm_use_tls = str2bool($cm_use_tls)
  } else {
    $safe_cm_use_tls = $cm_use_tls
  }

  $use_parcels = $::cloudera_use_parcels ? {
    undef => true,
    default => $::cloudera_use_parcels,
  }
  if is_string($use_parcels) {
    $safe_use_parcels = str2bool($use_parcels)
  } else {
    $safe_use_parcels = $use_parcels
  }

  $use_gplextras = $::cloudera_use_gplextras ? {
    undef => false,
    default => $::cloudera_use_gplextras,
  }
  if is_string($use_gplextras) {
    $safe_use_gplextras = str2bool($use_gplextras)
  } else {
    $safe_use_gplextras = $use_gplextras
  }

  $install_java = $::cloudera_install_java ? {
    undef => true,
    default => $::cloudera_install_java,
  }
  if is_string($install_java) {
    $safe_install_java = str2bool($install_java)
  } else {
    $safe_install_java = $install_java
  }

  $install_jce = $::cloudera_install_jce ? {
    undef => false,
    default => $::cloudera_install_jce,
  }
  if is_string($install_jce) {
    $safe_install_jce = str2bool($install_jce)
  } else {
    $safe_install_jce = $install_jce
  }

  if $::operatingsystemmajrelease { # facter 1.7+
    $majdistrelease = $::operatingsystemmajrelease
  } elsif $::lsbmajdistrelease {    # requires LSB to already be installed
    $majdistrelease = $::lsbmajdistrelease
  } elsif $::os_maj_version {       # requires stahnma/epel
    $majdistrelease = $::os_maj_version
  } else {
    $majdistrelease = regsubst($::operatingsystemrelease,'^(\d+)\.(\d+)','\1')
  }

  $cdh_version = '4'
  $cm_version  = '4'
  $ci_version  = '1'
  $cs_version  = '1'
  $cg_version  = '4'

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      $java_package_name = 'jdk'
      $cdh_yumpath = "/cdh4/redhat/${majdistrelease}/${::architecture}/cdh/"
      $cm_yumpath = "/cm4/redhat/${majdistrelease}/${::architecture}/cm/"
      $ci_yumpath = "/impala/redhat/${majdistrelease}/${::architecture}/impala/"
      $cs_yumpath = "/search/redhat/${majdistrelease}/${::architecture}/search/"
      $cg_yumpath = "/gplextras/redhat/${majdistrelease}/${::architecture}/gplextras/"
    }
    'SLES': {
      $java_package_name = 'jdk'
      #$package_provider = 'zypper'
      $cdh_yumpath = "/cdh4/sles/${majdistrelease}/${::architecture}/cdh/"
      $cm_yumpath = "/cm4/sles/${majdistrelease}/${::architecture}/cm/"
      $ci_yumpath = "/impala/sles/${majdistrelease}/${::architecture}/impala/"
      $cs_yumpath = "/search/sles/${majdistrelease}/${::architecture}/search/"
      $cg_yumpath = "/gplextras/sles/${majdistrelease}/${::architecture}/gplextras/"
    }
    'Debian': {
      $java_package_name = 'oracle-j2sdk1.6'
      $cdh_yumpath = "/cdh4/debian/${::lsbdistcodename}/${::architecture}/cdh/"
      $cm_yumpath = "/cm4/debian/${::lsbdistcodename}/${::architecture}/cm/"
      $ci_yumpath = "/impala/debian/${::lsbdistcodename}/${::architecture}/impala/"
      $cs_yumpath = "/search/debian/${::lsbdistcodename}/${::architecture}/search/"
      $cg_yumpath = "/gplextras/debian/${::lsbdistcodename}/${::architecture}/gplextras/"
      $cdh_aptkey = false
      $cm_aptkey = '327574EE02A818DD'
      $ci_aptkey = false
      $cs_aptkey = false
      $cg_aptkey = false
    }
    'Ubuntu': {
      $java_package_name = 'oracle-j2sdk1.6'
      $cdh_yumpath = "/cdh4/ubuntu/${::lsbdistcodename}/${::architecture}/cdh/"
      $cm_yumpath = "/cm4/ubuntu/${::lsbdistcodename}/${::architecture}/cm/"
      $ci_yumpath = "/impala/ubuntu/${::lsbdistcodename}/${::architecture}/impala/"
      $cs_yumpath = "/search/ubuntu/${::lsbdistcodename}/${::architecture}/search/"
      $cg_yumpath = "/gplextras/ubuntu/${::lsbdistcodename}/${::architecture}/gplextras/"
      $cdh_aptkey = false
      $cm_aptkey = '327574EE02A818DD'
      $ci_aptkey = false
      $cs_aptkey = false
      $cg_aptkey = false
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}
