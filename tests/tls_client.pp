# The node that will be the CM agent may use this declaration:
$cmserver = 'localhost'
class { 'cloudera::repo': } ->
class { 'cloudera::java': } ->
class { 'cloudera::java::jce': } ->
class { 'cloudera::cm':
  server_host => $cmserver,
  use_tls     => true,
}
file { '/etc/pki/tls/certs/cloudera_manager.crt':
  ensure => present,
  source => "puppet:///modules/cloudera/cloudera_manager_chain.crt",
  mode   => '0644',
  owner  => 'root',
  group  => 'root',
  before => Class['cloudera::cm'],
}
