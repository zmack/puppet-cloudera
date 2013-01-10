# == Class: cloudera::params
#
# This class handles OS-specific configuration of the cloudera module.  It
# looks for variables in top scope (probably from an ENC such as Dashboard).  If
# the variable doesn't exist in top scope, it falls back to a hard coded default
# value.
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::params {
### The following parameters should not need to be changed.

  # If we have a top scope variable defined, use it, otherwise fall back to a
  # hardcoded value.
  $yumserver = $::cloudera_yumserver ? {
    undef   => 'http://archive.cloudera.com',
    default => $::cloudera_yumserver,
  }

  case $::operatingsystem {
    'CentOS', 'RedHat', 'OEL', 'OracleLinux': {
      $cdh_yumpath = "/cdh4/redhat/${::os_maj_version}/${::architecture}/cdh/"
      $cm_yumpath = "/cm4/redhat/${::os_maj_version}/${::architecture}/cm/"
    }
    default: {
      fail("Module ${module} is not supported on ${::operatingsystem}")
    }
  }
}
