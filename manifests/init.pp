# == Class: cloudera
#
# This class handles installing the Cloudera software with the intention
# of the CDH stack being managed by Cloudera Manager.
#
# === Parameters:
#
# [*ensure*]
#   Ensure if present or absent.
#   Default: present
#
# [*autoupgrade*]
#   Upgrade package automatically, if there is a newer version.
#   Default: false
#
# [*service_ensure*]
#   Ensure if service is running or stopped.
#   Default: running
#
# [*service_enable*]
#   Start service at boot.
#   Default: true
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
# [*cs_yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cs_yumpath*]
#   The path to add to the $cs_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cs_version*]
#   The version of Cloudera Search to install.
#   Default: 1
#
# [*cg_yumserver*]
#   URI of the YUM server.
#   Default: http://archive.cloudera.com
#
# [*cg_yumpath*]
#   The path to add to the $cg_yumserver URI.
#   Only set this if your platform is not supported or you know what you are
#   doing.
#   Default: auto-set, platform specific
#
# [*cg_version*]
#   The version of Cloudera Search to install.
#   Default: 4
#
# [*cm_server_host*]
#   Hostname of the Cloudera Manager server.
#   Default: localhost
#
# [*cm_server_port*]
#   Port to which the Cloudera Manager server is listening.
#   Default: 7182
#
# [*use_tls*]
#   Whether to enable TLS on the Cloudera Manager agent. TLS needs to be enabled
#   on the server prior to setting this to true.
#   Default: false
#
# [*verify_cert_file*]
#   The file holding the public key of the Cloudera Manager server as well as
#   the chain of signing certificate authorities. PEM format.
#   Default: /etc/pki/tls/certs/cloudera_manager.crt
#
# [*use_parcels*]
#   Whether to use parcel format software install and not RPM.
#   Default: true
#
# [*use_gplextras*]
#   Whether to install the GPL LZO compression libraries.
#   Default: false
#
# [*install_java*]
#   Whether to install the Cloudera supplied Oracle Java Development Kit.  If
#   this is set to false, then an Oracle JDK will have to be installed prior to
#   applying this module.
#   Default: true
#
# [*install_jce*]
#   Whether to install the Oracle Java Cryptography Extension unlimited
#   strength jurisdiction policy files.  This requires manual download of the
#   zip file.  See files/README_JCE.md for download instructions.
#   Default: false
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
# Package['jdk'] which is provided by Class['cloudera::java'].  If parameter
# "$install_java => false", then an external Puppet module will have to install
# the Sun/Oracle JDK and provide a Package['jdk'] resource.
#
# === Sample Usage:
#
#   class { 'cloudera':
#     cdh_version    => '4.1',
#     cm_version     => '4.1',
#     cm_server_host => 'smhost.example.com',
#   }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#  Copyright (c) 2011, Cloudera, Inc. All Rights Reserved.
#
#  Cloudera, Inc. licenses this file to you under the Apache License,
#  Version 2.0 (the "License"). You may not use this file except in
#  compliance with the License. You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  This software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#  CONDITIONS OF ANY KIND, either express or implied. See the License for
#  the specific language governing permissions and limitations under the
#  License.
#
class cloudera (
  $ensure           = $cloudera::params::ensure,
  $autoupgrade      = $cloudera::params::safe_autoupgrade,
  $service_ensure   = $cloudera::params::service_ensure,
  $service_enable   = $cloudera::params::safe_service_enable,
  $cdh_yumserver    = $cloudera::params::cdh_yumserver,
  $cdh_yumpath      = $cloudera::params::cdh_yumpath,
  $cdh_version      = $cloudera::params::cdh_version,
  $cm_yumserver     = $cloudera::params::cm_yumserver,
  $cm_yumpath       = $cloudera::params::cm_yumpath,
  $cm_version       = $cloudera::params::cm_version,
  $ci_yumserver     = $cloudera::params::ci_yumserver,
  $ci_yumpath       = $cloudera::params::ci_yumpath,
  $ci_version       = $cloudera::params::ci_version,
  $cs_yumserver     = $cloudera::params::cs_yumserver,
  $cs_yumpath       = $cloudera::params::cs_yumpath,
  $cs_version       = $cloudera::params::cs_version,
  $cg_yumserver     = $cloudera::params::cg_yumserver,
  $cg_yumpath       = $cloudera::params::cg_yumpath,
  $cg_version       = $cloudera::params::cg_version,
  $cm_server_host   = $cloudera::params::cm_server_host,
  $cm_server_port   = $cloudera::params::cm_server_port,
  $use_tls          = $cloudera::params::safe_cm_use_tls,
  $verify_cert_file = $cloudera::params::verify_cert_file,
  $use_parcels      = $cloudera::params::safe_use_parcels,
  $use_gplextras    = $cloudera::params::safe_use_gplextras,
  $install_java     = $cloudera::params::safe_install_java,
  $install_jce      = $cloudera::params::safe_install_jce,
  $proxy            = $cloudera::params::proxy,
  $proxy_username   = $cloudera::params::proxy_username,
  $proxy_password   = $cloudera::params::proxy_password
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)
  validate_bool($use_tls)
  validate_bool($use_parcels)
  validate_bool($use_gplextras)
  validate_bool($install_java)
  validate_bool($install_jce)

  anchor { 'cloudera::begin': }
  anchor { 'cloudera::end': }

  if $install_java {
    Class['cloudera::cm::repo'] -> Class['cloudera::java']
    class { 'cloudera::java':
      ensure      => $ensure,
      autoupgrade => $autoupgrade,
      require     => Anchor['cloudera::begin'],
      before      => Anchor['cloudera::end'],
    }
    if $install_jce {
      class { 'cloudera::java::jce':
        ensure  => $ensure,
        require => [ Anchor['cloudera::begin'], Class['cloudera::java'], ],
        before  => Anchor['cloudera::end'],
      }
    }
    $cloudera_cm_require = [ Anchor['cloudera::begin'], Class[cloudera::java], ]
  } else {
    $cloudera_cm_require = Anchor['cloudera::begin']
  }
#  Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-manager'|>
#  Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-gplextras'|>
#  Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-search'|>
#  Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-cdh4'|>
#  Package<|tag == 'jdk' and (tag == 'sun' or tag == 'oracle')|> -> Package<|tag == 'cloudera-impala'|>

  class { 'cloudera::cm':
    ensure           => $ensure,
    autoupgrade      => $autoupgrade,
    service_ensure   => $service_ensure,
#    service_enable   => $service_enable,
    server_host      => $cm_server_host,
    server_port      => $cm_server_port,
    use_tls          => $use_tls,
    verify_cert_file => $verify_cert_file,
    require          => $cloudera_cm_require,
    before           => Anchor['cloudera::end'],
  }
  class { 'cloudera::cm::repo':
    ensure         => $ensure,
    yumserver      => $cm_yumserver,
    yumpath        => $cm_yumpath,
    version        => $cm_version,
    proxy          => $proxy,
    proxy_username => $proxy_username,
    proxy_password => $proxy_password,
    require        => Anchor['cloudera::begin'],
    before         => Anchor['cloudera::end'],
  }
  # Skip installing the CDH RPMs if we are going to use parcels.
  if ! $use_parcels {
    class { 'cloudera::cdh::repo':
      ensure         => $ensure,
      yumserver      => $cdh_yumserver,
      yumpath        => $cdh_yumpath,
      version        => $cdh_version,
      proxy          => $proxy,
      proxy_username => $proxy_username,
      proxy_password => $proxy_password,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    class { 'cloudera::impala::repo':
      ensure         => $ensure,
      yumserver      => $ci_yumserver,
      yumpath        => $ci_yumpath,
      version        => $ci_version,
      proxy          => $proxy,
      proxy_username => $proxy_username,
      proxy_password => $proxy_password,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    class { 'cloudera::search::repo':
      ensure         => $ensure,
      yumserver      => $cs_yumserver,
      yumpath        => $cs_yumpath,
      version        => $cs_version,
      proxy          => $proxy,
      proxy_username => $proxy_username,
      proxy_password => $proxy_password,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    class { 'cloudera::cdh':
      ensure         => $ensure,
      autoupgrade    => $autoupgrade,
      service_ensure => $service_ensure,
#      service_enable => $service_enable,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    class { 'cloudera::impala':
      ensure         => $ensure,
      autoupgrade    => $autoupgrade,
      service_ensure => $service_ensure,
#      service_enable => $service_enable,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    class { 'cloudera::search':
      ensure         => $ensure,
      autoupgrade    => $autoupgrade,
      service_ensure => $service_ensure,
#      service_enable => $service_enable,
      require        => Anchor['cloudera::begin'],
      before         => Anchor['cloudera::end'],
    }
    if $use_gplextras {
      class { 'cloudera::gplextras::repo':
        ensure         => $ensure,
        yumserver      => $cg_yumserver,
        yumpath        => $cg_yumpath,
        version        => $cg_version,
        proxy          => $proxy,
        proxy_username => $proxy_username,
        proxy_password => $proxy_password,
        require        => Anchor['cloudera::begin'],
        before         => Anchor['cloudera::end'],
      }
      class { 'cloudera::gplextras':
        ensure      => $ensure,
        autoupgrade => $autoupgrade,
        require     => Anchor['cloudera::begin'],
        before      => Anchor['cloudera::end'],
      }
    }
  }
}
