require 'spec_helper'

describe 'senlin::client' do

  shared_examples_for 'senlin client' do

    it { is_expected.to contain_class('senlin::deps') }
    it { is_expected.to contain_class('senlin::params') }

    it 'installs senlin client package' do
      is_expected.to contain_package('python-senlinclient').with(
        :ensure => 'present',
        :name   => platform_params[:client_package_name],
        :tag    => 'openstack',
      )
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let(:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :client_package_name => 'python3-senlinclient' }
        when 'RedHat'
          { :client_package_name => 'python3-senlinclient' }
        end
      end

      it_configures 'senlin client'
    end
  end

end
