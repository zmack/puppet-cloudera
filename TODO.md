# TODO
## For 1.0.0 release:

* default parcels
* update dependencies (mysql/postgresql)
* separate install impala (manifests/impala/bla.pp)
* separate install search (manifests/search/bla.pp)
* refactor ::repo to autoinclude in cdh/impala/search
* support SLES/Debian/Ubuntu?
* clean out commented code

## For 2.0.0 release:

* support CM5 / CDH5 / Oracle JDK 7
* remove CDH (RPM) support?

## Other:

* support TLS level 3
* PostgreSQL must be configured to accept connections with md5 password authentication.  To do so, edit /var/lib/pgsql/data/pg_hba.conf (or similar) to include `host all all 127.0.0.1/32 md5` *above* a similar line that allows `ident` authentication.
* cm_api support
* parcels still require LZO OS libraries?
* Add HDFS FUSE mounting support.
* Support pig-udf installation.
* Document hive-server installation.
* Document hive-metastore installation.
* Document sqoop-metastore installation.
* Document whirr installation.

## Links

http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM5/latest/Cloudera-Manager-Version-and-Download-Information/Cloudera-Manager-Version-and-Download-Information.html
http://archive.cloudera.com/cm5/redhat/6/x86_64/cm/5/

http://www.cloudera.com/content/cloudera-content/cloudera-docs/CDH5/latest/CDH-Version-and-Packaging-Information/cdhvd_topic_2.html
http://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/5/

http://www.cloudera.com/content/cloudera-content/cloudera-docs/Search/latest/Cloudera-Search-Version-and-Download-Information/Cloudera-Search-Version-and-Download-Information.html
http://archive.cloudera.com/search/redhat/6/x86_64/search/

http://www.cloudera.com/content/cloudera-content/cloudera-docs/Impala/latest/Cloudera-Impala-Version-and-Download-Information/Cloudera-Impala-Version-and-Download-Information.html
http://archive.cloudera.com/impala/redhat/6/x86_64/impala/

http://www.cloudera.com/content/cloudera-content/cloudera-docs/CM4Ent/latest/Cloudera-Manager-Installation-Guide/cmig_install_LZO_Compression.html
http://archive.cloudera.com/gplextras5/redhat/6/x86_64/gplextras/
http://archive.cloudera.com/gplextras/redhat/6/x86_64/gplextras/

