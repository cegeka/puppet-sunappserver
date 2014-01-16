#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::config' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with run_as => appserv and imq_type => REMOTE and imq_home => /opt/appserver/imq' do
    let (:params) { { :runas => 'appserv', :imq_type => 'REMOTE', :imq_home => '/opt/appserver/imq' } }

    it { should contain_class('sunappserver::params') }

    it { should contain_file('/etc/sysconfig/sunappserver') }
    it { should contain_file('/opt/appserver/imq').with_owner('appserv') }
    it { should contain_augeas('domain/configs/config/jms-service/type/REMOTE') }

  end

end
