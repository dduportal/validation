# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include ci_agent_tools::tools
class ci_agent_tools::tools {
  exec { 'apt-get update':
    command => '/usr/bin/apt-get update',
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin
      | /bin/grep . > /dev/null'";
  }

  $packages = ['vim','git','hugo']
  package { $packages:
    ensure  => 'installed',
    require => Exec['apt-get update'];
  }
}
