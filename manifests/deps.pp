# == Class: senlin::deps
#
# senlin anchors and dependency management
#
class senlin::deps {
  # Setup anchors for install, config and service phases of the module.  These
  # anchors allow external modules to hook the begin and end of any of these
  # phases.  Package or service management can also be replaced by ensuring the
  # package is absent or turning off service management and having the
  # replacement depend on the appropriate anchors.  When applicable, end tags
  # should be notified so that subscribers can determine if installation,
  # config or service state changed and act on that if needed.
  anchor { 'senlin::install::begin': }
  -> Package<| tag == 'senlin-package'|>
  ~> anchor { 'senlin::install::end': }
  -> anchor { 'senlin::config::begin': }
  -> Senlin_config<||>
  ~> anchor { 'senlin::config::end': }
  -> anchor { 'senlin::db::begin': }
  -> anchor { 'senlin::db::end': }
  ~> anchor { 'senlin::dbsync::begin': }
  -> anchor { 'senlin::dbsync::end': }
  ~> anchor { 'senlin::service::begin': }
  ~> Service<| tag == 'senlin-service' |>
  ~> anchor { 'senlin::service::end': }

  # all db settings should be applied and all packages should be installed
  # before dbsync starts
  Oslo::Db<||> -> Anchor['senlin::dbsync::begin']

  # policy config should occur in the config block also.
  Anchor['senlin::config::begin']
  -> Openstacklib::Policy::Base<||>
  ~> Anchor['senlin::config::end']

  # Installation or config changes will always restart services.
  Anchor['senlin::install::end'] ~> Anchor['senlin::service::begin']
  Anchor['senlin::config::end']  ~> Anchor['senlin::service::begin']
}
