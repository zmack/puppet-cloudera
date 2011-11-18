# Puppet module to install Cloudera's Distribution for Apache Hadoop and Cloudera Manager

## Description

This module contains four primary classes:

### cloudera::cdh

Installs the components of Cloudera’s Distribution for Hadoop (CDH), and, with two exceptions, leaves them unconfigured. Including `cloudera::cdh` directly will install the Hadoop, HBase, Hive, ZooKeeper, Pig, Oozie, Mahout, and Hue packages. In addition, you can install each of the components individually, by including only the relevant class in this namespace (for instance, including `cloudera::cdh::hbase` will result in HBase being installed).

Since neither Sqoop nor Flume is currently managed by Cloudera Manager, `cloudera::cdh::sqoop` and `cloudera::cdh::flume` contain classes to start those components’ services directly from Puppet: `cloudera::cdh::flume::node`, `cloudera::cdh::flume::master`, and `cloudera::cdh::sqoop::metastore`.

This class is automatically included if you `include cloudera`.


### cloudera::plugins

Installs the Cloudera Manager plugins for CDH. 

This class is automatically included if you `include cloudera`.

### cloudera::scm-agent

Installs, configures, and starts the Cloudera Manager Agent, which should be running on every
node of your cluster.  Usage is detailed below.

This class is automatically included if you `include cloudera`.

### cloudera::scm-server

Installs, configures, and starts the Cloudera Manager Server.  Generally, should only
be included for one host in your cluster, and, as such, is *not* included automatically
in from the `cloudera` class.  For information about usage, skip ahead to the section titled "Usage".

### General Notes

Note that, in order for this module to work, you will have to ensure that:

 * Oracle JRE version 6 or later is installed
 * The MySQL JDBC connector is installed
 * Your package manager is configured with a repository containing the CDH packages
 * If installing Cloudera Manager Server, MySQL must be installed and running on the host and port (and using the credentials) provided to cloudera::scm-server::params.

For more information, see the "Cloudera Manager Installation Guide" at:
[https://ccp.cloudera.com/display/ENT/Cloudera+Manager+Installation+Guide](https://ccp.cloudera.com/display/ENT/Cloudera+Manager+Installation+Guide)

## Usage

<pre>
host 'scm-master' {
  include cloudera # includes all components except for Cloudera Manager Server
 
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

 * $server\_host (defaults to "localhost"): FQDN or IP address to use when connecting to the Cloudera Manager Server
 * $server\_port (defaults to "7182"): TCP port to use when connecting to the Cloudera Manager Server

### cloudera::scm-server::params

 * $db\_name (defaults to "cmf"): Name of the MySQL database that the Cloudera Manager Server will use
 * $db\_user (defaults to "cmf"): User that the Cloudera Manager Server should use when authenticating to MySQL
 * $db\_pass: Password that the Cloudera Manager Server should use when authenticating to MySQL
 * $db\_admin\_user (defaults to "root"): Name of a user with permission to administer MySQL
 * $db\_admin\_pass (defaults to undef): Password to use when authenticating as $db\_admin\_user.
