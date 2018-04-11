# == Class: senlin::keystone::auth
#
# Configures senlin user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (required) Password for senlin user.
#
# [*ensure*]
#   (optional) Ensure state of keystone service identity. Defaults to 'present'.
#
# [*auth_name*]
#   Username for senlin service. Defaults to 'senlin'.
#
# [*email*]
#   Email for senlin user. Defaults to 'senlin@localhost'.
#
# [*tenant*]
#   Tenant for senlin user. Defaults to 'services'.
#
# [*configure_endpoint*]
#   Should senlin endpoint be configured? Defaults to 'true'.
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to 'true'.
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to 'true'.
#
# [*service_type*]
#   Type of service. Defaults to 'key-manager'.
#
# [*region*]
#   Region for endpoint. Defaults to 'RegionOne'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to the value of 'senlin'.
#
# [*service_description*]
#   (optional) Description of the service.
#   Default to 'senlin FIXME Service'
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:FIXME')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:FIXME')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:FIXME')
#
class senlin::keystone::auth (
  $password,
  $ensure              = 'present',
  $auth_name           = 'senlin',
  $email               = 'senlin@localhost',
  $tenant              = 'services',
  $configure_endpoint  = true,
  $configure_user      = true,
  $configure_user_role = true,
  $service_name        = 'senlin',
  $service_description = 'senlin FIXME Service',
  $service_type        = 'FIXME',
  $region              = 'RegionOne',
  $public_url          = 'http://127.0.0.1:FIXME',
  $admin_url           = 'http://127.0.0.1:FIXME',
  $internal_url        = 'http://127.0.0.1:FIXME',
) {

  include ::senlin::deps

  if $configure_user_role {
    Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'senlin-server' |>
  }
  Keystone_endpoint["${region}/${service_name}::${service_type}"]  ~> Service <| name == 'senlin-server' |>

  keystone::resource::service_identity { 'senlin':
    ensure              => $ensure,
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_name        => $service_name,
    service_type        => $service_type,
    service_description => $service_description,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    internal_url        => $internal_url,
    admin_url           => $admin_url,
  }

}
