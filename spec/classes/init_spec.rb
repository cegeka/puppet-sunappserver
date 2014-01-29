#!/usr/bin/env rspec

require 'spec_helper'

describe 'sunappserver' do

  context 'on osfamily RedHat' do
    let (:facts) { {
      :osfamily => 'RedHat'
    } }

    context 'with faulty input' do
      context 'with service_state => foo' do
        let (:params) { { :service_state => 'foo' } }

        it { expect { subject }.to raise_error(
          Puppet::Error, /parameter service_state must be running or stopped/
        )}
      end

      context 'with imq_type => foo' do
        let (:params) { { :imq_type => 'foo' } }

        it { expect { subject }.to raise_error(
          Puppet::Error, /parameter imq_type must be remote or embedded/
        )}
      end
    end

    context 'with service_state => foo' do
      let (:params) { { :service_state => 'foo' } }

      it { expect { subject }.to raise_error(
        Puppet::Error, /parameter service_state must be running or stopped/
      )}
    end

    context 'with default parameters' do
      let (:params) { { } }

      it { should contain_class('sunappserver::params') }

      it { should contain_class('sunappserver').with_ensure('present') }
      it { should contain_class('sunappserver').without_appserver_version }
      it { should contain_class('sunappserver').with_service_state('running') }
      it { should contain_class('sunappserver').with_service_enable(true) }
      it { should contain_class('sunappserver').with_runas('appserv') }
      it { should contain_class('sunappserver').with_imq_type('remote') }
      it { should contain_class('sunappserver').with_imq_home('/opt/appserver/imq') }
      it { should contain_class('sunappserver').with_imq_port('7676') }

      it { should contain_class('sunappserver::package').with_ensure('present') }

      it { should contain_class('sunappserver::config').with_runas('appserv') }
      it { should contain_class('sunappserver::config').with_imq_type('REMOTE') }
      it { should contain_class('sunappserver::config').with_imq_home('/opt/appserver/imq') }

      it { should contain_sunappserver__config__service('domain1').with_runas('appserv') }
      it { should contain_sunappserver__config__service('domain1').with_appserv_installroot('/opt/appserver') }

      it { should contain_class('sunappserver::service').with_ensure('running') }
      it { should contain_class('sunappserver::service').with_enable(true) }

      it { should contain_class('sunappserver::config').with_notify('Class[Sunappserver::Service]') }
      it { should contain_sunappserver__config__service('domain1').with_notify('Class[Sunappserver::Service]') }

      # Light weight version of the anchor pattern
      it { should contain_class('sunappserver::config').with_before('Class[Sunappserver]') }
    end

    context 'with imq_type => remote' do
      let (:params) { { :imq_type => 'remote' } }

      it { should contain_class('sunappserver::config::imq') }
      it { should contain_class('sunappserver::imq::service') }
    end

    context 'with imq_type => embedded' do
      let (:params) { { :imq_type => 'embedded' } }

      it { should contain_class('sunappserver::config::imq').with_ensure('absent') }
      it { should_not contain_class('sunappserver::imq::service') }
    end

  end

  context 'on osfamily Debian' do
    let (:facts) { {
      :osfamily => 'Debian'
    } }

    it { expect { subject }.to raise_error( Puppet::Error, /not supported/) }
  end

end
