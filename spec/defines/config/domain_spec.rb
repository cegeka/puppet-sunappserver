#!/usr/bin/env ruby

require 'spec_helper'

describe 'sunappserver::config::domain' do
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

          it { should contain_sunappserver__config__domain('foodomain').with(
            :ensure              => 'present',
            :appserv_installroot => '/opt/appserver',
            :runas               => 'appserv',
            :imq_type            => 'remote'
          )}

          it { should contain_file('service/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0755',
            :path   => '/etc/init.d/sunappserver-foodomain',
            :source => 'puppet:///modules/sunappserver/config/domain'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644',
            :path   => '/etc/sysconfig/sunappserver-foodomain'
          )}

          it { should contain_file('/opt/appserver/domains/foodomain').with(
            :ensure => 'directory',
            :owner  => 'appserv',
            :mode   => '0750'
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

          it { should contain_augeas('foodomain/config/jms-service/type').with(
            :lens    => 'Xml.lns',
            :incl    => '/opt/appserver/domains/foodomain/config/domain.xml',
            :changes => [ 'set domain/configs/config/jms-service/#attribute/type REMOTE' ]
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

          it { should contain_file('/opt/appserver/domains/foodomain').with(
            :ensure => 'absent',
            :force  => true
          )}
        end

        context 'with runas => foo, imq_type => embedded and appserv_installroot => /tmp' do
          let (:params) { {
            :runas               => 'foo',
            :imq_type            => 'embedded',
            :appserv_installroot => '/tmp'
          } }

          it { should contain_file('service/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0755',
            :path   => '/etc/init.d/sunappserver-foodomain',
            :source => 'puppet:///modules/sunappserver/config/domain'
          )}

          it { should contain_file('sysconfig/sunappserver-foodomain').with(
            :ensure => 'file',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0644',
            :path   => '/etc/sysconfig/sunappserver-foodomain'
          )}

          it { should contain_file('/tmp/domains/foodomain').with(
            :ensure => 'directory',
            :owner  => 'foo',
            :mode   => '0750'
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

          it { should contain_augeas('foodomain/config/jms-service/type').with(
            :lens    => 'Xml.lns',
            :incl    => '/tmp/domains/foodomain/config/domain.xml',
            :changes => [ 'set domain/configs/config/jms-service/#attribute/type EMBEDDED' ]
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

        it { should contain_file('/opt/appserver/domains/domain1').with(
          :ensure => 'absent',
          :force  => true
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
          :source => 'puppet:///modules/sunappserver/config/domain'
        )}

        it { should contain_file('sysconfig/sunappserver-domain1').with(
          :ensure => 'file',
          :owner  => 'root',
          :group  => 'root',
          :mode   => '0644',
          :path   => '/etc/sysconfig/sunappserver'
        )}

        it { should contain_file('/opt/appserver/domains/domain1').with(
          :ensure => 'directory',
          :owner  => 'appserv',
          :mode   => '0750'
        )}

        it { should contain_augeas('domain1/config/jms-service/type').with(
          :lens    => 'Xml.lns',
          :incl    => '/opt/appserver/domains/domain1/config/domain.xml',
          :changes => [ 'set domain/configs/config/jms-service/#attribute/type REMOTE' ]
        )}
      end
    end
  end
end
