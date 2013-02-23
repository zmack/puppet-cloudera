name 'razorsedge-cloudera'
version '0.6.1'

author 'razorsedge'
license 'Apache License, Version 2.0'
project_page 'https://github.com/razorsedge/puppet-cloudera'
source 'git://github.com/razorsedge/puppet-cloudera.git'
summary 'Puppet module to deploy Cloudera Manager and Cloudera\'s Distribution, including Apache Hadoop (CDH).'
description 'This module manages the installation of Cloudera\'s Distribution, including Apache Hadoop (CDH) and
Cloudera Manager. It follows the standards written in the Cloudera Manager Installation Guide Installation Path B
- Installation Using Your Own Method. It also includes installing the beta version of Cloudera Impala.'
dependency 'puppetlabs/stdlib', '>=2.3.0'
dependency 'puppetlabs/mysql', '>=0.6.0'
dependency 'puppetlabs/postgresql', '>=2.1.0'
dependency 'nanliu/staging', '>=0.2.1'
dependency 'stahnma/epel', '>=0.0.3'

# Generate the changelog file
system("git-log-to-changelog > CHANGELOG")
$? == 0 or fail "changelog generation #{$?}!"
