# == Class: cloudera::cdh::hue::plugins
#
# This class installes the HUE plugins.
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
#   class { 'cloudera::cdh::hue::plugins': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::cdh::hue::plugins {
  package { 'hue-plugins':
    ensure => 'present',
  }
}
