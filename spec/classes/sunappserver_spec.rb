#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver' do

  context "with RedHat as OS" do
    let (:facts) {{ :operatingsystem => 'redhat' }}

    context "and with appserver_version => 9.1.01" do
      let (:params) {{ :appserver_version => '9.1.01' }}
      
      it { should contain_package('sunappserver').with_ensure('9.1.01') }
    end

    context "and without appserver_version parameter, without ensure parameter" do
      it { should contain_package('sunappserver').with_ensure('latest') }
    end

    context "and with ensure => present, without appserver_version parameter" do
      let (:params) {{ :ensure => 'present' }}

      it { should contain_package('sunappserver').with_ensure('latest') }
    end

    context "and with ensure => absent, without appserver_version parameter" do
      let (:params) {{ :ensure => 'absent' }}

      it { should contain_package('sunappserver').with_ensure('absent') }
    end

    context "and with ensure => absent, with appserver_version => 9.1.01" do
      let (:params) {{ :appserver_version => '9.1.01', :ensure => 'absent' }}

      it { should contain_package('sunappserver').with_ensure('absent') }
    end

  end

end
