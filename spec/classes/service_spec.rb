#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver::service' do

  let(:facts) { {
    :osfamily => 'RedHat'
  } }

  context 'with service_state => running and imq_state => running' do
    let (:params) { { :service_state => 'running', :imq_state => 'running' } }

    it { should contain_class('sunappserver::params') }

    it { should contain_service('sunappserver').with_ensure('running') }

    it { should contain_service('imq').with_ensure('running') }
    it { should contain_service('imq').with_before('Service[sunappserver]') }
  end

end
