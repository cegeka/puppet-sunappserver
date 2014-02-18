#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::config::imq' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'without prior inclusion of class sunappserver::params' do
    let (:pre_condition) { '' }

    it { expect { subject }.to raise_error(
      Puppet::Error, /must include the sunappserver::params class before/
    )}
  end

  context 'with prior inclusion of class sunappserver::params' do
    let (:pre_condition) { 'include sunappserver::params' }

    context 'with ensure => running' do
      let (:params) { {
        :ensure => 'running'
      } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter ensure must be present or absent/
      )}
    end

    context 'with ensure => absent' do
      let (:params) { {
        :ensure => 'absent'
      } }

      it { should contain_file('service/imq').with(
        :ensure => 'absent',
        :path   => '/etc/init.d/imq'
      )}

      it { should contain_file('sysconfig/imq').with(
        :ensure => 'absent',
        :path   => '/etc/sysconfig/imq'
      )}
    end

    context 'with default parameters' do
      let (:params) { { } }

      it { should contain_class('sunappserver::config::imq').with(
        :ensure              => 'present',
        :runas               => 'appserv',
        :appserv_installroot => '/opt/appserver',
        :imq_port            => '7676'
      )}
    end

    context 'ensure => present, appserv_installroot => /tmp and imq_port => 7777' do
      let (:params) { {
        :ensure              => 'present',
        :appserv_installroot => '/tmp',
        :imq_port            => '7777'
      } }

      it { should contain_file('service/imq').with(
        :ensure => 'file',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0750',
        :path   => '/etc/init.d/imq',
        :source => 'puppet:///modules/sunappserver/config/imq'
      )}

      it { should contain_file('sysconfig/imq').with(
        :ensure  => 'file',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0644',
        :path    => '/etc/sysconfig/imq'
      )}

      it { should contain_file('/tmp/imq').with(
        :ensure  => 'directory',
        :owner   => 'appserv',
        :mode    => '0750'
      )}

      it { should contain_file('sysconfig/imq').with(
        :content => /^IMQHOME="\/tmp\/imq"$/
      )}

      it { should contain_file('sysconfig/imq').with(
        :content => /^IMQPORT="7777"$/
      )}

      it { should contain_file('sysconfig/imq').with(
        :content => /^USER="appserv"$/
      )}
    end
  end
end
