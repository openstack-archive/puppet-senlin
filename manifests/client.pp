# == Class senlin::client
#
# Installs the senlin client.
#
# == Parameters
#
#  [*ensure*]
#    (Optional) The state for the senlin client package.
#    Defaults to 'present'.
#
class senlin::client (
  $ensure = 'present'
) {

  include senlin::deps
  include senlin::params

  package { 'python-senlinclient':
    ensure => $ensure,
    name   => $::senlin::params::client_package_name,
    tag    => 'openstack',
  }

  include '::openstacklib::openstackclient'

}
