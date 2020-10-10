require 'spec_helper'

describe 'senlin::db::postgresql' do

  let :pre_condition do
    'include postgresql::server'
  end

  let :required_params do
    { :password => 'senlinpass' }
  end

  shared_examples_for 'senlin-db-postgresql' do
    context 'with only required parameters' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('senlin::deps') }

      it { is_expected.to contain_openstacklib__db__postgresql('senlin').with(
        :user       => 'senlin',
        :password   => 'senlinpass',
        :dbname     => 'senlin',
        :encoding   => nil,
        :privileges => 'ALL',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :concat_basedir => '/var/lib/puppet/concat' }))
      end

      it_behaves_like 'senlin-db-postgresql'
    end
  end
end
