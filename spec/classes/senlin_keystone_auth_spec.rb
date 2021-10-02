#
# Unit tests for senlin::keystone::auth
#

require 'spec_helper'

describe 'senlin::keystone::auth' do
  shared_examples_for 'senlin::keystone::auth' do
    context 'with default class parameters' do
      let :params do
        { :password => 'senlin_password' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('senlin').with(
        :configure_user      => true,
        :configure_user_role => true,
        :configure_endpoint  => true,
        :service_name        => 'senlin',
        :service_type        => 'clustering',
        :service_description => 'Senlin Clustering Service',
        :region              => 'RegionOne',
        :auth_name           => 'senlin',
        :password            => 'senlin_password',
        :email               => 'senlin@localhost',
        :tenant              => 'services',
        :public_url          => 'http://127.0.0.1:8778',
        :internal_url        => 'http://127.0.0.1:8778',
        :admin_url           => 'http://127.0.0.1:8778',
      ) }
    end

    context 'when overriding parameters' do
      let :params do
        { :password            => 'senlin_password',
          :auth_name           => 'alt_senlin',
          :email               => 'alt_senlin@alt_localhost',
          :tenant              => 'alt_service',
          :configure_endpoint  => false,
          :configure_user      => false,
          :configure_user_role => false,
          :service_description => 'Alternative Senlin Clustering Service',
          :service_name        => 'alt_service',
          :service_type        => 'alt_clustering',
          :region              => 'RegionTwo',
          :public_url          => 'https://10.10.10.10:80',
          :internal_url        => 'http://10.10.10.11:81',
          :admin_url           => 'http://10.10.10.12:81' }
      end

      it { is_expected.to contain_keystone__resource__service_identity('senlin').with(
        :configure_user      => false,
        :configure_user_role => false,
        :configure_endpoint  => false,
        :service_name        => 'alt_service',
        :service_type        => 'alt_clustering',
        :service_description => 'Alternative Senlin Clustering Service',
        :region              => 'RegionTwo',
        :auth_name           => 'alt_senlin',
        :password            => 'senlin_password',
        :email               => 'alt_senlin@alt_localhost',
        :tenant              => 'alt_service',
        :public_url          => 'https://10.10.10.10:80',
        :internal_url        => 'http://10.10.10.11:81',
        :admin_url           => 'http://10.10.10.12:81',
      ) }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'senlin::keystone::auth'
    end
  end
end
