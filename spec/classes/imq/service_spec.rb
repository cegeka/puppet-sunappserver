#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::imq::service' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with ensure => absent' do
    let (:params) { {
      :ensure => 'absent'
    } }

    it { expect { subject }.to raise_error(
      Puppet::Error, /parameter ensure must be running, stopped or unmanaged/
    )}
  end

  context 'with default parameters' do
    let (:params) { { } }

    it { should contain_class('sunappserver::imq::service').with(
      :ensure     => 'running',
      :enable     => true
    )}
  end

  context 'with ensure => running' do
    let (:params) { {
      :ensure => 'running'
    } }

    it { should contain_service('imq').with(
      :ensure    => 'running',
      :enable    => true,
      :hasstatus => true
    )}
  end

  context 'ensure => stopped and enable => false' do
    let (:params) { {
      :ensure   => 'stopped',
      :enable   => false,
    } }

    it { should contain_service('imq').with(
      :ensure    => 'stopped',
      :enable    => false,
      :hasstatus => true
    )}
  end
end
