###
### File managed by Puppet
###
if [ -d /usr/java/default ]; then
  export JAVA_HOME=/usr/java/default
elif [ -d /usr/lib/jvm/j2sdk1.6-oracle ]; then
  export JAVA_HOME=/usr/lib/jvm/j2sdk1.6-oracle
fi
#export PATH=$PATH:$JAVA_HOME/bin
