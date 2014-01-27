#!/usr/bin/env rspec

require 'spec_helper'

describe 'cloudera', :type => 'class' do

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
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    it { should compile.with_all_deps }
    it { should contain_class('cloudera::java').with_ensure('present') }
    it { should contain_class('cloudera::cm').with_ensure('present') }
    it { should_not contain_class('cloudera::cdh::repo') }
    it { should contain_class('cloudera::cm::repo').with_ensure('present') }
    it { should_not contain_class('cloudera::cdh') }
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end

    describe 'ensure => absent' do
      let(:params) {{ :ensure => 'absent' }}
      it { should contain_class('cloudera::java').with_ensure('absent') }
      it { should contain_class('cloudera::cm').with_ensure('absent') }
      it { should contain_class('cloudera::cm::repo').with_ensure('absent') }
    end

    describe 'use_parcels => false' do
      let(:params) {{ :use_parcels => false }}
      it { should contain_class('cloudera::java').with_ensure('present') }
      it { should contain_class('cloudera::cm').with_ensure('present') }
      it { should contain_class('cloudera::cdh::repo').with_ensure('present') }
      it { should contain_class('cloudera::cm::repo').with_ensure('present') }
      it { should contain_class('cloudera::cdh').with_ensure('present') }
      it { should contain_class('cloudera::impala::repo').with_ensure('present') }
      it { should contain_class('cloudera::impala').with_ensure('present') }
    end
  end

end
