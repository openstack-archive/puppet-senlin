#
# Unit tests for senlin::keystone::auth
#

require 'spec_helper'

describe 'senlin::keystone::auth' do
  shared_examples_for 'senlin-keystone-auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'senlin_password',
          :tenant   => 'foobar' }
      end

      it { is_expected.to contain_keystone_user('senlin').with(
        :ensure   => 'present',
        :password => 'senlin_password',
      ) }

      it { is_expected.to contain_keystone_user_role('senlin@foobar').with(
        :ensure  => 'present',
        :roles   => ['admin']
      )}

      it { is_expected.to contain_keystone_service('senlin::clustering').with(
        :ensure      => 'present',
        :description => 'Senlin Clustering Service'
      ) }

      it { is_expected.to contain_keystone_endpoint('RegionOne/senlin::clustering').with(
        :ensure       => 'present',
        :public_url   => 'http://127.0.0.1:8778',
        :admin_url    => 'http://127.0.0.1:8778',
        :internal_url => 'http://127.0.0.1:8778',
      ) }
    end

    context 'when overriding URL parameters' do
      let :params do
        { :password     => 'senlin_password',
          :public_url   => 'https://10.10.10.10:80',
          :internal_url => 'http://10.10.10.11:81',
          :admin_url    => 'http://10.10.10.12:81', }
      end

      it { is_expected.to contain_keystone_endpoint('RegionOne/senlin::clustering').with(
        :ensure       => 'present',
        :public_url   => 'https://10.10.10.10:80',
        :internal_url => 'http://10.10.10.11:81',
        :admin_url    => 'http://10.10.10.12:81',
      ) }
    end

    context 'when overriding auth name' do
      let :params do
        { :password => 'foo',
          :auth_name => 'senliny' }
      end

      it { is_expected.to contain_keystone_user('senliny') }
      it { is_expected.to contain_keystone_user_role('senliny@services') }
      it { is_expected.to contain_keystone_service('senlin::clustering') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/senlin::clustering') }
    end

    context 'when overriding service name' do
      let :params do
        { :service_name => 'senlin_service',
          :auth_name    => 'senlin',
          :password     => 'senlin_password' }
      end

      it { is_expected.to contain_keystone_user('senlin') }
      it { is_expected.to contain_keystone_user_role('senlin@services') }
      it { is_expected.to contain_keystone_service('senlin_service::clustering') }
      it { is_expected.to contain_keystone_endpoint('RegionOne/senlin_service::clustering') }
    end

    context 'when disabling user configuration' do

      let :params do
        {
          :password       => 'senlin_password',
          :configure_user => false
        }
      end

      it { is_expected.not_to contain_keystone_user('senlin') }
      it { is_expected.to contain_keystone_user_role('senlin@services') }
      it { is_expected.to contain_keystone_service('senlin::clustering').with(
        :ensure      => 'present',
        :description => 'Senlin Clustering Service'
      ) }

    end

    context 'when disabling user and user role configuration' do

      let :params do
        {
          :password            => 'senlin_password',
          :configure_user      => false,
          :configure_user_role => false
        }
      end

      it { is_expected.not_to contain_keystone_user('senlin') }
      it { is_expected.not_to contain_keystone_user_role('senlin@services') }
      it { is_expected.to contain_keystone_service('senlin::clustering').with(
        :ensure      => 'present',
        :description => 'Senlin Clustering Service'
      ) }

    end

    context 'when using ensure absent' do

      let :params do
        {
          :password => 'senlin_password',
          :ensure   => 'absent'
        }
      end

      it { is_expected.to contain_keystone__resource__service_identity('senlin').with_ensure('absent') }

    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'senlin-keystone-auth'
    end
  end
end
