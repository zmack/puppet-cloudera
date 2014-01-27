#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::cdh::repo', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Module cloudera is not supported on bar/)
    end
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
    it { should compile.with_all_deps }
    it { should contain_yumrepo('cloudera-cdh4').with(
      :descr          => 'Cloudera\'s Distribution for Hadoop, Version 4',
      :enabled        => '1',
      :gpgcheck       => '1',
      :gpgkey         => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera',
      :baseurl        => 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/',
      :priority       => '50',
      :protect        => '0',
      :proxy          => 'absent',
      :proxy_username => 'absent',
      :proxy_password => 'absent'
    )}
    it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644'
    )}
    it { should_not contain_yumrepo('cloudera-impala') }
    it { should_not contain_yumrepo('cloudera-manager') }
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
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with_ensure('file') }
    end

    describe 'all other parameters' do
      let :params do {
        :cdh_yumserver  => 'http://localhost',
        :cdh_yumpath    => '/somepath/',
        :cdh_version    => '999',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      }
      end
      it { should contain_yumrepo('cloudera-cdh4').with(
        :gpgkey         => 'http://localhost/somepath/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/999/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-cdh4.repo').with_ensure('file') }
    end
  end
end
