#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::package' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with ensure => present and version => 9.1.01' do
    let (:params) { { :ensure => 'present', :appserver_version => '9.1.01' } }

    it { should contain_class('sunappserver::params') }
    it { should contain_package('sunappserver').with_ensure('9.1.01') }
  end

end
