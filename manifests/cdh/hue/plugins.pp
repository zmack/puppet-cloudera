class cloudera::cdh::hue::plugins {
  package { 'hue-plugins':
    ensure => 'present',
  }
}
