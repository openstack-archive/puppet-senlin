# Parameters for puppet-senlin
#
class senlin::params {

  include senlin::deps
  include openstacklib::defaults

  $client_package_name = 'python3-senlinclient'
  $group               = 'senlin'


  case $::osfamily {
    'RedHat': {
    }
    'Debian': {
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem")
    }

  } # Case $::osfamily
}
