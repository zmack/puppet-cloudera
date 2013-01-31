#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::repo', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
      }
    end
#    it { should_not contain_yumrepo('cloudera-cdh4') }
#    it { should_not contain_yumrepo('cloudera-manager') }
#    it { should_not contain_yumrepo('cloudera-impala') }
  end

  context 'on a supported operatingsystem, default parameters' do
    let :facts do {
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6.3',
      :os_maj_version         => '6',
      :architecture           => 'x86_64'
    }
    end
    it { should contain_yumrepo('cloudera-cdh4').with(
      :descr    => 'Cloudera\'s Distribution for Hadoop, Version 4',
      :enabled  => '1',
      :gpgcheck => '1',
      :gpgkey   => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera',
      :baseurl  => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/',
      :priority => '50',
      :protect  => '0'
    )}
    it { should contain_yumrepo('cloudera-manager').with(
      :descr    => 'Cloudera Manager',
      :enabled  => '1',
      :gpgcheck => '1',
      :gpgkey   => 'http://archive.cloudera.com/cm4/redhat/6/x86_64/cm/RPM-GPG-KEY-cloudera',
      :baseurl  => 'http://archive.cloudera.com/cm4/redhat/6/x86_64/cm/4/',
      :priority => '50',
      :protect  => '0'
    )}
    it { should contain_yumrepo('cloudera-impala').with(
      :descr    => 'Impala',
      :enabled  => '1',
      :gpgcheck => '1',
      :gpgkey   => 'http://beta.cloudera.com/impala/redhat/6/x86_64/impala/RPM-GPG-KEY-cloudera',
      :baseurl  => 'http://beta.cloudera.com/impala/redhat/6/x86_64/impala/0/',
      :priority => '50',
      :protect  => '0'
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'OracleLinux'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_yumrepo('cloudera-cdh4').with_enabled('0') }
      it { should contain_yumrepo('cloudera-manager').with_enabled('0') }
      it { should contain_yumrepo('cloudera-impala').with_enabled('0') }
    end

    describe 'all other parameters' do
      let :params do {
        :cdh_yumserver => 'http://localhost',
        :cdh_yumpath   => '/somepath/',
        :cdh_version   => '999',
        :cm_yumserver => 'http://localhost',
        :cm_yumpath   => '/somepath/3/',
        :cm_version   => '888',
        :ci_yumserver => 'http://localhost',
        :ci_yumpath   => '/somepath/2/',
        :ci_version   => '777'
      }
      end
      it { should contain_yumrepo('cloudera-cdh4').with(
        :gpgkey   => 'http://localhost/somepath/RPM-GPG-KEY-cloudera',
        :baseurl  => 'http://localhost/somepath/999/'
      )}
      it { should contain_yumrepo('cloudera-manager').with(
        :gpgkey   => 'http://localhost/somepath/3/RPM-GPG-KEY-cloudera',
        :baseurl  => 'http://localhost/somepath/3/888/'
      )}
      it { should contain_yumrepo('cloudera-impala').with(
        :gpgkey   => 'http://localhost/somepath/2/RPM-GPG-KEY-cloudera',
        :baseurl  => 'http://localhost/somepath/2/777/'
      )}
    end
  end
end
