require 'spec_helper'

describe 'senlin::policy' do
  shared_examples_for 'senlin-policies' do
    let :params do
      {
        :policy_path => '/etc/senlin/policy.yaml',
        :policies    => {
          'context_is_admin' => {
            'key'   => 'context_is_admin',
            'value' => 'foo:bar'
          }
        }
      }
    end

    it 'set up the policies' do
      is_expected.to contain_openstacklib__policy__base('context_is_admin').with({
        :key        => 'context_is_admin',
        :value      => 'foo:bar',
        :file_user  => 'root',
        :file_group => 'senlin',
      })
      is_expected.to contain_oslo__policy('senlin_config').with(
        :policy_file => '/etc/senlin/policy.yaml',
      )
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'senlin-policies'
    end
  end
end
