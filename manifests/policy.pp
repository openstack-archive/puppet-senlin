# == Class: senlin::policy
#
# Configure the senlin policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for senlin
#   Example :
#     {
#       'senlin-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'senlin-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the nova policy.json file
#   Defaults to /etc/senlin/policy.json
#
class senlin::policy (
  $policies    = {},
  $policy_path = '/etc/senlin/policy.json',
) {

  include ::senlin::deps
  include ::senlin::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::senlin::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'senlin_config': policy_file => $policy_path }

}
