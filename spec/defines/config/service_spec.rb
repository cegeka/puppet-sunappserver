#!/usr/bin/env ruby

require 'spec_helper'

describe 'sunappserver::config::service' do
  context 'with title foodomain' do
    let (:title) { 'foodomain' }

    context 'without prior inclusion of class sunappserver::params' do

      it { expect { subject }.to raise_error(
        Puppet::Error, /must include the sunappserver::params class before/
      )}
    end

    context 'with prior inclusion of class sunappserver' do
      let (:pre_condition) { 'include sunappserver::params' }

      context 'on osfamily RedHat' do
        let (:facts) { {
          :osfamily => 'RedHat'
        } }

        context 'with ensure => running' do
          let (:params) { { :ensure => 'running' } }

          it { expect { subject }.to raise_error(
            Puppet::Error, /parameter ensure must be present or absent/
          )}
        end

        context 'with default parameters' do
          let (:params) { { } }

          it { should contain_sunappserver__config__service('foodomain').with(
            :ensure              => 'present',
            :appserv_installroot => '/opt/appserver',
            :runas               => 'appserv'
          )}

          it { should contain_file('service/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0755',
            :path   => '/etc/init.d/sunappserver-foodomain',
            :source => 'puppet:///modules/sunappserver/config/service'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644',
            :path   => '/etc/sysconfig/sunappserver-foodomain'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^APPSERVDIR="\/opt\/appserver"$/
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^USER="appserv"$/
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^MAINTENANCE_FILE="\$\{APPSERVDIR\}\/\.maintenance"$/
          )}

        end

        context 'with ensure => absent' do
          let (:params) { { :ensure => 'absent' } }

          it { should contain_file('service/sunappserver-foodomain').with(
            :ensure => 'absent',
            :path   => '/etc/init.d/sunappserver-foodomain'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :ensure => 'absent',
            :path   => '/etc/sysconfig/sunappserver-foodomain'
          )}
        end

        context 'with runas => foo and appserv_installroot => /tmp' do
          let (:params) { {
            :runas               => 'foo',
            :appserv_installroot => '/tmp'
          } }

          it { should contain_file('service/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0755',
            :path   => '/etc/init.d/sunappserver-foodomain',
            :source => 'puppet:///modules/sunappserver/config/service'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644',
            :path   => '/etc/sysconfig/sunappserver-foodomain'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^APPSERVDIR="\/tmp"$/
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^USER="foo"$/
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :content => /^MAINTENANCE_FILE="\$\{APPSERVDIR\}\/\.maintenance"$/
          )}

        end
      end

      context 'on osfamily Debian' do
        let (:facts) { {
          :osfamily => 'Debian'
        } }

        it { expect { subject }.to raise_error(
          Puppet::Error, /not supported/
        )}
      end
    end
  end

  context 'with title domain1' do
    let (:title) { 'domain1' }

    context 'with prior inclusion of class sunappserver::params on osfamily RedHat' do
      let (:pre_condition) { 'include sunappserver::params' }
      let (:facts) { {
        :osfamily => 'RedHat'
      } }

      context 'with ensure => absent' do
        let (:params) { { :ensure => 'absent' } }

        it { should contain_file('service/sunappserver-domain1').with(
          :ensure => 'absent',
          :path   => '/etc/init.d/sunappserver'
        )}

        it { should contain_file('sysconfig/sunappserver-domain1').with(
          :ensure => 'absent',
          :path   => '/etc/sysconfig/sunappserver'
        )}
      end

      context 'with default parameters' do
        let (:params) { { } }

        it { should contain_file('service/sunappserver-domain1').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0755',
          :path   => '/etc/init.d/sunappserver',
          :source => 'puppet:///modules/sunappserver/config/service'
        )}

        it { should contain_file('sysconfig/sunappserver-domain1').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
          :path   => '/etc/sysconfig/sunappserver'
        )}
      end
    end
  end
end
