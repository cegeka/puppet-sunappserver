#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::service' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with ensure => present' do
    let (:params) { {
      :ensure => 'present'
    } }

    it { expect { subject }.to raise_error(
      Puppet::Error, /parameter ensure must be running or stopped/
    )}
  end

  context 'with ensure => stopped' do
    let (:params) { {
      :ensure => 'stopped'
    } }

    it { should contain_service('sunappserver').with(
      :ensure => 'stopped',
      :hasstatus => true
    )}
  end

  context 'with default parameters' do
    let (:params) { { } }

    it { should contain_class('sunappserver::service').with(
      :ensure     => 'running'
    )}
  end

  context 'imq_state => running and imq_enable => true' do
    let (:params) { {
      :imq_state  => 'running',
      :imq_enable => true
    } }

  end
end
