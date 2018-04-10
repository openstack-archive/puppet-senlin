# Parameters for puppet-senlin
#
class senlin::params {

  include ::senlin::deps

  include ::openstacklib::defaults

  $group = 'senlin'


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
