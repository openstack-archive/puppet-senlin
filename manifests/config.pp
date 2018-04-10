# == Class: senlin::config
#
# This class is used to manage arbitrary senlin configurations.
#
# === Parameters
#
# [*senlin_config*]
#   (optional) Allow configuration of arbitrary senlin configurations.
#   The value is an hash of senlin_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   senlin_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class senlin::config (
  $senlin_config = {},
) {

  include ::senlin::deps

  validate_hash($senlin_config)

  create_resources('senlin_config', $senlin_config)
}
