#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::redhat' do

  context "with RedHat as OS" do
    let (:facts) {{ :operatingsystem => 'redhat' }}

    context "and with appserver_version => 9.1.01" do
      #let (:params) {{ :appserver_version => '9.1.01', :runas => 'appserv', :imq_home => '/data/imq', :imq_port => '7676' }}
      #it { should contain_package('sunappserver').with_ensure('9.1.01') }
      it { should contain_package('sunappserver') }
      it { should contain_service('sunappserver') }
      it { should contain_service('imq') }
      it { should contain_exec('modify-ownership-for-appserver-root') }
    end

  end

end
