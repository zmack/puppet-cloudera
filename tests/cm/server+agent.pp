class { 'cloudera':
  cm_server_host => 'smhost.example.com',
  use_parcels    => true,
} ->
class { 'cloudera::cm::server': }
