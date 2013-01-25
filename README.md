Puppet Cloudera Manager and CDH4 Module
=======================================

master branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-cloudera.png?branch=master)](http://travis-ci.org/razorsedge/puppet-cloudera)
develop branch: [![Build Status](https://secure.travis-ci.org/razorsedge/puppet-cloudera.png?branch=develop)](http://travis-ci.org/razorsedge/puppet-cloudera)

Introduction
------------

This module manages the installation of [Cloudera's Distribution, including Apache Hadoop (CDH)](http://www.cloudera.com/content/cloudera/en/products/cdh.html) and [Cloudera Manager](http://www.cloudera.com/content/cloudera/en/products/cloudera-manager.html).  It follows the standards written in the (Cloudera Manager Installation Guide)[https://ccp.cloudera.com/display/ENT41DOC/Cloudera+Manager+Installation+Guide] (Installation Path B - Installation Using Your Own Method)[https://ccp.cloudera.com/display/ENT41DOC/Installation+Path+B+-+Installation+Using+Your+Own+Method].  It also includes installing the beta version of (Cloudera Impala)[https://ccp.cloudera.com/display/IMPALA10BETADOC/Cloudera+Impala+1.0+Beta+Documentation].

Actions:

* Installs the Cloudera software repositories for CDH, CM, and Impala beta.
* Installs Oracle JDK 6.
* Installs most components of CDH 4.
* Installs CM 4 agent.
* Installs Impala beta.
* Configures the CM agent to talk to a CM server.
* Starts the CM agent.
* Separately installs the CM server and database connectivity (by default to the embedded database server).
* Separately starts the CM server.

Software Support:

* CDH              - tested with 4.1.2; CDH3 is presently unsuported (patches welcome)
* Cloudera Manager - tested with 4.1

OS Support:

* RedHat family - tested on CentOS 6.3+
* SuSE family   - presently unsupported (patches welcome)
* Debian family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

Class Descriptions
------------------

### Class['cloudera']

Meta-class that includes:
* Class['cloudera::repo']
* Class['cloudera::java']
* Class['cloudera::cdh']
* Class['cloudera::cm']
Requires the parameter `cm_server_host`.

### Class['cloudera::repo']

This class handles installing the Cloudera software repositories.

### Class['cloudera::java']

This class handles installing the Oracle JDK from the Cloudera Manager repository.

### Class['cloudera::cdh']

This class handles installing the Cloudera Distribution, including Apache Hadoop.  No configuration is performed on the CDH software and all daemons are forced off so that Cloudera Manager can manage them.  This class installs Bigtop utils, Hadoop (HDFS, MapReduce, YARN), Hue-plugins, HBase, Hive, Oozie, Pig, ZooKeeper, Flume-NG, and Impala.

### Class['cloudera::cdh::hue']

This class handles installing Hue.  This class is not currently included in Class['cloudera::cdh'] as that would conflict with the Cloudera installation instructions.

### Class['cloudera::cm']

This class handles installing and configuring the Cloudera Manager Agent.  This agent should be running on every node in the cluster so that Cloudera Manager can deploy software configurations to the node.  Requires the parameter `server_host`.

### Class['cloudera::cm::server']

This class handles installing and configuring the Cloudera Manager Server.  This class should only be included on one node for you environment.  By default it will install the embeded PostgreSQL database on the same node.  With the correct parameters, it can also connect to local or remote MySQL, PostgreSQL, and Oracle RDBMS databases.


Examples
--------

    # Most nodes in the cluster will use this declaration:
    class { 'cloudera':
      cm_server_host => 'smhost.example.com',
    }


    # Nodes that will be Gateways may use this declaration:
    class { 'cloudera':
      cm_server_host => 'smhost.example.com',
    }
    class { 'cloudera::cdh::hue': }
    class { 'cloudera::cdh::mahout': }
    class { 'cloudera::cdh::sqoop': }
    # Install Oozie WebUI support (optional):
    #class { 'cloudera::cdh::oozie::ext': }
    # Install MySQL support (optional):
    #class { 'cloudera::cdh::hue::mysql': }
    #class { 'cloudera::cdh::oozie::mysql': }


    # The node that will be the CM server may use this declaration:
    # This will skip installation of the CDH software as it is not required.
    class { 'cloudera::repo':
      cdh_version => '4.1',
      cm_version  => '4.1',
    } ->
    class { 'cloudera::java': } ->
    class { 'cloudera::cm': } ->
    class { 'cloudera::cm::server': }


Notes
-----

* Supports Top Scope variables (i.e. via Dashboard) and Parameterized Classes.
* Installing CDH3 is not presently supported.

Issues
------

* None

TODO
----

* None

License
-------

Please see LICENSE file.

Copyright
---------

Copyright (C) 2013 Mike Arnold <mike@razorsedge.org>

[razorsedge/puppet-cloudera on GitHub](https://github.com/razorsedge/puppet-cloudera)

[razorsedge/cloudera on Puppet Forge](http://forge.puppetlabs.com/razorsedge/cloudera)

