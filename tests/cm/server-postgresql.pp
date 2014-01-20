class { 'cloudera::cm::repo': } ->
class { 'cloudera::java': } ->
class { 'cloudera::cm::server':
  db_type => 'postgresql',
  db_user => 'postgres',
  db_pass => '',
  db_port => '5432',
}

include '::postgresql::server'
#class { 'cloudera':
#  cm_server_host => 'smhost.example.com',
#} ->
#class { 'cloudera::cm::server':
#  db_type => 'postgresql',
#}
