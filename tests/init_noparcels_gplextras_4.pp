class { 'cloudera':
  cm_server_host => 'localhost',
  use_parcels    => false,
  use_gplextras  => true,
  cdh_version    => '4',
}
