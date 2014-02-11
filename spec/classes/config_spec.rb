#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::config' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with run_as => appserv and appserv_installroot => /opt/appserver' do
    let (:params) { {
      :runas => 'appserv',
      :appserv_installroot => '/opt/appserver'
    } }

    it { should contain_class('sunappserver::params') }
  end
end
