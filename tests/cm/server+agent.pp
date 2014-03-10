class { 'cloudera':
  cm_server_host => 'localhost',
  use_parcels    => true,
  cm_version     => '4',
} ->
class { 'cloudera::cm::server': }
