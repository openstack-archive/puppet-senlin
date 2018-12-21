# == Class: senlin::db::postgresql
#
# Class that configures postgresql for senlin
# Requires the Puppetlabs postgresql module.
#
# === Parameters
#
# [*password*]
#   (Required) Password to connect to the database.
#
# [*dbname*]
#   (Optional) Name of the database.
#   Defaults to 'senlin'.
#
# [*user*]
#   (Optional) User to connect to the database.
#   Defaults to 'senlin'.
#
#  [*encoding*]
#    (Optional) The charset to use for the database.
#    Default to undef.
#
#  [*privileges*]
#    (Optional) Privileges given to the database user.
#    Default to 'ALL'
#
class senlin::db::postgresql(
  $password,
  $dbname     = 'senlin',
  $user       = 'senlin',
  $encoding   = undef,
  $privileges = 'ALL',
) {

  include ::senlin::deps

  ::openstacklib::db::postgresql { 'senlin':
    password_hash => postgresql_password($user, $password),
    dbname        => $dbname,
    user          => $user,
    encoding      => $encoding,
    privileges    => $privileges,
  }

  Anchor['senlin::db::begin']
  ~> Class['senlin::db::postgresql']
  ~> Anchor['senlin::db::end']

}
