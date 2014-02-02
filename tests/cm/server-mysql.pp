class { 'cloudera::cm::repo': } ->
class { 'cloudera::java': } ->
class { 'cloudera::cm::server':
  db_type => 'mysql',
}

include '::mysql::server'
#class { 'cloudera':
#  cm_server_host => 'localhost',
#} ->
#class { 'cloudera::cm::server':
#  db_type => 'mysql',
#}
