#
# Class to execute senlin-manage db_sync
#
# == Parameters
#
# [*extra_params*]
#   (Optional) String of extra command line parameters to append
#   to the senlin-dbsync command.
#   Defaults to undef
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class senlin::db::sync(
  $extra_params    = undef,
  $db_sync_timeout = 300,
) {

  include senlin::deps

  exec { 'senlin-db-sync':
    command     => "senlin-manage db_sync ${extra_params}",
    path        => [ '/bin', '/usr/bin' ],
    user        => 'senlin',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
    logoutput   => on_failure,
    subscribe   => [
      Anchor['senlin::install::end'],
      Anchor['senlin::config::end'],
      Anchor['senlin::dbsync::begin']
    ],
    notify      => Anchor['senlin::dbsync::end'],
    tag         => 'openstack-db',
  }
}
