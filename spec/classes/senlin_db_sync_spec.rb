require 'spec_helper'

describe 'senlin::db::sync' do

  shared_examples_for 'senlin-dbsync' do

    it 'runs senlin-db-sync' do
      is_expected.to contain_exec('senlin-db-sync').with(
        :command     => 'senlin-manage db_sync ',
        :path        => [ '/bin', '/usr/bin', ],
        :refreshonly => 'true',
        :try_sleep   => 5,
        :tries       => 10,
        :user        => 'senlin',
        :logoutput   => 'on_failure',
        :subscribe   => ['Anchor[senlin::install::end]',
                         'Anchor[senlin::config::end]',
                         'Anchor[senlin::dbsync::begin]'],
        :notify      => 'Anchor[senlin::dbsync::end]',
        :tag         => 'openstack-db',
      )
    end

  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts({
          :os_workers     => 8,
          :concat_basedir => '/var/lib/puppet/concat'
        }))
      end

      it_configures 'senlin-dbsync'
    end
  end

end
