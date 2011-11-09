# Puppet module to install Cloudera's Distribution for Apache Hadoop and Cloudera Enterprise

## Description

Note that, in order for this module to work, you will have to ensure that:

* sun jre version 6 or greater is installed
* the mysql jdbc connector is installed
* your package manager is configured with a repository containing the
  cdh packages
* If installing scm-server, mysqld must be installed and running as
    well, on the host and port (and using the credentials) provided
    to cloudera::scm-server::params.

## Usage

<pre>
host 'scm-master' {
  include cloudera # includes all components except for SCM server

  class { 'cloudera::scm-server::params':
    db_pass       => $db_cmf_pw,
    db_admin_pass => $db_root_pw,
  }
  include cloudera::scm-server
}

host 'cdh-node' {
  class { 'cloudera::scm-agent::params':
    server_host => $scm_master_fqdn,
  }
  include cloudera
}
</pre>

## Configurable Options

### cloudera::scm-agent::params
  * $server\_host (defaults to "localhost"): FQDN or IP address to use when connecting to the SCM master
  * $server\_port (defaults to "7182"): TCP port to use when connecting to the SCM master

### cloudera::scm-server::params
  * $db\_name (defaults to "cmf"): Name of the mysql database that Cloudera SCM will use
  * $db\_user (defaults to "cmf"): User that SCM should use when authenticating to mysql
  * $db\_pass: Password that SCM should use when authenticating to mysql
  * $db\_admin\_user (defaults to "root"): Name of a user with permission to administer mysql
  * $db\_admin\_pass (defaults to undef): Password to use when authenticating as $db\_admin\_user.
