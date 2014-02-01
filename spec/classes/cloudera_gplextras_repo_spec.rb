#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::gplextras::repo', :type => 'class' do

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
    it { should contain_yumrepo('cloudera-gplextras4').with(
      :descr          => 'Cloudera GPL Extras',
      :enabled        => '1',
      :gpgcheck       => '1',
      :gpgkey         => 'http://archive.cloudera.com/gplextras/redhat/6/x86_64/gplextras/RPM-GPG-KEY-cloudera',
      :baseurl        => 'http://archive.cloudera.com/gplextras/redhat/6/x86_64/gplextras/4/',
      :priority       => '50',
      :protect        => '0',
      :proxy          => 'absent',
      :proxy_username => 'absent',
      :proxy_password => 'absent'
    )}
    it { should contain_file('/etc/yum.repos.d/cloudera-gplextras4.repo').with(
      :ensure => 'file',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0644'
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
      it { should contain_yumrepo('cloudera-gplextras4').with_enabled('0') }
      it { should contain_file('/etc/yum.repos.d/cloudera-gplextras4.repo').with_ensure('file') }
    end

    describe 'all other parameters' do
      let :params do {
        :yumserver      => 'http://localhost',
        :yumpath        => '/somepath/2/',
        :version        => '777',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      }
      end
      it { should contain_yumrepo('cloudera-gplextras4').with(
        :gpgkey         => 'http://localhost/somepath/2/RPM-GPG-KEY-cloudera',
        :baseurl        => 'http://localhost/somepath/2/777/',
        :proxy          => 'http://proxy:3128/',
        :proxy_username => 'myUser',
        :proxy_password => 'myPass'
      )}
      it { should contain_file('/etc/yum.repos.d/cloudera-gplextras4.repo').with_ensure('file') }
    end
  end
end
