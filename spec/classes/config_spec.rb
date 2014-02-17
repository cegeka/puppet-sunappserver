#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::config' do

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

    context 'with default parameters' do
      let (:params) { { } }

      it { should contain_class('sunappserver::config').with(
        :runas => 'appserv',
        :appserv_installroot => '/opt/appserver'
      )}
    end

    context 'with run_as => foo and appserv_installroot => /tmp' do
      let (:params) { {
        :runas => 'foo',
        :appserv_installroot => '/tmp'
      } }

      it { should contain_exec('modify-ownership-for-appserver-root').with(
        :command => '/bin/chown -R foo /tmp'
      )}
    end
  end
end
