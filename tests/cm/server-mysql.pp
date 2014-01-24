class { 'cloudera::cm::repo': } ->
class { 'cloudera::java': } ->
class { 'cloudera::cm::server':
  db_type => 'mysql',
}

include '::mysql::server'
#class { 'cloudera':
#  cm_server_host => 'smhost.example.com',
#} ->
#class { 'cloudera::cm::server':
#  db_type => 'mysql',
#}
