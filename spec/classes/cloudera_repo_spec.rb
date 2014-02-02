#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera::repo', :type => 'class' do

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
    it { should contain_class('cloudera::cdh::repo') }
    it { should contain_class('cloudera::impala::repo') }
    it { should contain_notify('cloudera::repo has been split into cloudera::cdh::repo and cloudera::impala::repo. This backwards compatibility shim will be removed on 02 April 2014.') }
  end
end
