# == Class: cloudera::cdh::oozie::ext
#
# This class handles installing the Oozie Web Console.
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
#   Define['wget::fetch']
#
# === Sample Usage:
#
#   class { 'cloudera::cdh::oozie::ext': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::cdh::oozie::ext {
  wget::fetch { 'ext-2.2.zip':
    source      => 'http://extjs.com/deploy/ext-2.2.zip',
    destination => '/usr/lib/oozie/libext/ext-2.2.zip',
  }

  file { '/var/lib/oozie/oozie-server/webapps':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'oozie',
    group  => 'oozie',
  }
}
