# 
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
  $ensure         = $cloudera::params::ensure,
  $autoupgrade    = $cloudera::params::autoupgrade,
  $service_ensure = $cloudera::params::service_ensure,
  $service_enable = $cloudera::params::safe_service_enable,
  $cdh_yumserver  = $cloudera::params::cdh_yumserver,
  $cdh_yumpath    = $cloudera::params::cdh_yumpath,
  $cdh_version    = $cloudera::params::cdh_version,
  $cm_yumserver   = $cloudera::params::cm_yumserver,
  $cm_yumpath     = $cloudera::params::cm_yumpath,
  $cm_version     = $cloudera::params::cm_version,
  $ci_yumserver   = $cloudera::params::ci_yumserver,
  $ci_yumpath     = $cloudera::params::cm_yumpath,
  $ci_version     = $cloudera::params::ci_version,
  $cm_server_host = $cloudera::params::cm_server_host,
  $cm_server_port = $cloudera::params::cm_server_port,
) inherits cloudera::params {
  # Validate our booleans
  validate_bool($autoupgrade)
  validate_bool($service_enable)

  Class['cloudera::repo'] -> Class['cloudera::cdh'] -> Class['cloudera::scm_agent']

  class { 'cloudera::repo':
    ensure        => $ensure,
    cdh_yumserver => $cdh_yumserver,
    cm_yumserver  => $cm_yumserver,
    ci_yumserver  => $ci_yumserver,
    cdh_yumpath   => $cdh_yumpath,
    cm_yumpath    => $cm_yumpath,
    ci_yumpath    => $cm_yumpath,
    cdh_version   => $cdh_version,
    cm_version    => $cm_version,
    ci_version    => $ci_version,
  }
  class { 'cloudera::cdh':
    ensure         => $ensure,
    autoupgrade    => $autoupgrade,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }
  class { 'cloudera::scm_agent':
    ensure         => $ensure,
    autoupgrade    => $autoupgrade,
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    server_host    => $cm_server_host,
    server_port    => $cm_server_port,
  }
}
