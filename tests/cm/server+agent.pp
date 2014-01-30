class { 'cloudera':
  cm_server_host => 'localhost',
  use_parcels    => true,
} ->
class { 'cloudera::cm::server': }
